#!/usr/bin/env python3
"""Aggregate AI-provenance audit over the URLs listed in a sitemap.

Stdlib-only: downloads each URL, classifies it by content type/suffix/magic,
and runs the same deterministic text/image/container inspections used by the
local audit. Optional external tools (c2patool/exiftool) are not invoked for
remote URLs; download the assets and run audit_dir.py locally for those.
"""

from __future__ import annotations

import argparse
import gzip
import sys
import tempfile
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from audit_lib import aggregate, print_human_report, scan_file
from common import emit_json, eprint

DEFAULT_MAX_BYTES = 4 << 20
DEFAULT_TIMEOUT = 15
DEFAULT_MAX_PAGES = 200
USER_AGENT = "remove-ai-marks-audit/1.0"

_EXT_FOR_KIND = {
    "png": ".png",
    "jpeg": ".jpg",
    "svg": ".svg",
    "pdf": ".pdf",
    "docx": ".docx",
    "odt": ".odt",
    "html": ".html",
    "markdown": ".md",
    "text": ".txt",
}


def _local(tag: str) -> str:
    return tag.rsplit("}", 1)[-1]


def parse_sitemap(data: bytes) -> tuple[str, list[str]]:
    """Parse a (possibly gzip-compressed) sitemap into (kind, urls)."""
    if data[:2] == b"\x1f\x8b":
        data = gzip.decompress(data)
    root = ET.fromstring(data)
    kind = _local(root.tag)
    urls = []
    for el in root.iter():
        if _local(el.tag) == "loc" and el.text:
            urls.append(el.text.strip())
    return kind, urls


def guess_kind(url: str, data: bytes, content_type: str | None = None) -> str:
    """Classify a downloaded URL from headers, suffix, then magic bytes."""
    ct = (content_type or "").lower().split(";")[0].strip()
    if "html" in ct:
        return "html"
    if ct == "image/png":
        return "png"
    if ct == "image/jpeg":
        return "jpeg"
    if "svg" in ct:
        return "svg"
    if ct == "application/pdf":
        return "pdf"
    if "wordprocessingml" in ct:
        return "docx"
    if "opendocument.text" in ct:
        return "odt"
    if "markdown" in ct:
        return "markdown"
    if ct == "text/plain":
        return "text"

    path = urllib.parse.urlparse(url).path.lower()
    for ext, kind in (
        (".png", "png"),
        (".jpg", "jpeg"),
        (".jpeg", "jpeg"),
        (".svg", "svg"),
        (".pdf", "pdf"),
        (".docx", "docx"),
        (".odt", "odt"),
        (".html", "html"),
        (".htm", "html"),
        (".md", "markdown"),
        (".markdown", "markdown"),
        (".txt", "text"),
    ):
        if path.endswith(ext):
            return kind

    if data.startswith(b"\x89PNG"):
        return "png"
    if data.startswith(b"\xff\xd8"):
        return "jpeg"
    if data.startswith(b"%PDF"):
        return "pdf"
    if data[:100].lstrip().startswith(b"<") and b"svg" in data[:500].lower():
        return "svg"
    if b"<html" in data[:2000].lower() or data[:100].lstrip().lower().startswith(b"<"):
        return "html"
    return "text"


def fetch(url: str, timeout: int, max_bytes: int) -> tuple[bytes, str | None]:
    """Fetch *url* with a byte cap; returns (body, content_type)."""
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        content_type = resp.headers.get("Content-Type")
        chunks = []
        total = 0
        while True:
            chunk = resp.read(1 << 16)
            if not chunk:
                break
            total += len(chunk)
            if total > max_bytes:
                raise ValueError(f"exceeds {max_bytes} bytes")
            chunks.append(chunk)
        return b"".join(chunks), content_type


def inspect_remote(url: str, data: bytes, content_type: str | None = None) -> dict:
    """Inspect downloaded bytes using the local scan_file pipeline."""
    kind = guess_kind(url, data, content_type)
    ext = _EXT_FOR_KIND.get(kind, ".bin")
    with tempfile.TemporaryDirectory() as td:
        tmp = Path(td) / f"asset{ext}"
        tmp.write_bytes(data)
        result = scan_file(tmp, display_name=url)
    result["kind"] = kind
    return result


def discover_sitemap(base_url: str, timeout: int) -> str | None:
    """Find a sitemap for *base_url* via /sitemap.xml then /robots.txt."""
    base = base_url.rstrip("/")
    for candidate in (f"{base}/sitemap.xml", f"{base}/sitemap_index.xml"):
        try:
            data, _ = fetch(candidate, timeout, DEFAULT_MAX_BYTES)
            parse_sitemap(data)
            return candidate
        except Exception:
            continue
    try:
        data, _ = fetch(f"{base}/robots.txt", timeout, 1 << 20)
        text = data.decode("utf-8", errors="replace")
        for line in text.splitlines():
            if line.lower().startswith("sitemap:"):
                return line.split(":", 1)[1].strip()
    except Exception:
        pass
    return None


def collect_urls(sitemap_url: str, timeout: int, max_pages: int) -> list[str]:
    """Collect page/asset URLs from a sitemap, following nested indexes."""
    urls: list[str] = []
    seen: set[str] = set()

    def _recurse(url: str, depth: int = 0) -> None:
        if len(urls) >= max_pages or depth > 3:
            return
        data, _ = fetch(url, timeout, DEFAULT_MAX_BYTES)
        kind, locs = parse_sitemap(data)
        if kind == "sitemapindex":
            for loc in locs:
                if loc not in seen:
                    seen.add(loc)
                    _recurse(loc, depth + 1)
        else:
            for loc in locs:
                if loc not in seen:
                    seen.add(loc)
                    urls.append(loc)

    _recurse(sitemap_url)
    return urls


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--sitemap", help="Sitemap URL to audit")
    p.add_argument("--base", help="Base URL; discover the sitemap automatically")
    p.add_argument("--max-pages", type=int, default=DEFAULT_MAX_PAGES)
    p.add_argument("--timeout", type=int, default=DEFAULT_TIMEOUT)
    p.add_argument("--max-bytes", type=int, default=DEFAULT_MAX_BYTES)
    p.add_argument("--json", action="store_true")
    args = p.parse_args()

    if not args.sitemap and not args.base:
        eprint("provide --sitemap URL or --base URL")
        return 2

    sitemap_url = args.sitemap
    if not sitemap_url:
        sitemap_url = discover_sitemap(args.base, args.timeout)
        if not sitemap_url:
            eprint(f"no sitemap found for {args.base}")
            return 2

    try:
        urls = collect_urls(sitemap_url, args.timeout, args.max_pages)
    except Exception as e:
        eprint(f"could not collect URLs from {sitemap_url}: {e}")
        return 2
    if not urls:
        eprint("no URLs collected from sitemap")
        return 2

    files = []
    failures = []
    for url in urls[: args.max_pages]:
        try:
            data, content_type = fetch(url, args.timeout, args.max_bytes)
        except Exception as e:
            failures.append({"url": url, "error": str(e)})
            continue
        try:
            files.append(inspect_remote(url, data, content_type))
        except Exception as e:
            failures.append({"url": url, "error": f"inspect failed: {e}"})

    summary = aggregate(files)
    report = {
        "sitemap": sitemap_url,
        "base": args.base,
        "urls_collected": len(urls),
        "urls_scanned": len(files),
        "urls_failed": failures,
        "summary": summary,
        "files": files,
    }

    if args.json:
        emit_json(report)
    else:
        print_human_report(
            files,
            summary,
            extra_header={
                "Sitemap": sitemap_url,
                "URLs collected": str(len(urls)),
                "URLs scanned": str(len(files)),
                "URLs failed": str(len(failures)),
            },
        )
        for failure in failures:
            print(f"  [error] {failure['url']}: {failure['error']}")

    return 1 if summary["actionable_files"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
