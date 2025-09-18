# Copilot Journals

## 2025-08-28T00:00:00Z

### Added VS Code Extension

Added `treefmt-vscode` extension from GitHub repository [https://github.com/isbecker/treefmt-vscode](https://github.com/isbecker/treefmt-vscode) by adding the following to the VS Code configuration:

1. Added `vscodeExtPublisher` and `vscodeExtName` parameters to the `buildVscodeExtension` function.
1. Fixed the extension declaration to properly use `lib.fakeSha256`.
1. Used the actual hash `sha256-8NTkPbTfAJkKqhG25vE5WlAFuJ+kldXLQDeEFdQYP5M=` for the extension after fetching it from the GitHub repository.
1. The hash was obtained using `nix-prefetch-git` command with the repository URL and commit revision.
1. The extension is configured to use the specific commit `e91d2246e1a1a684ac2065f329ed09fd6cc9dd08` from April 26, 2025.

### SHA256 Value Explanation

In the output from `nix-prefetch-git`, there are two hash values provided:

1. `sha256`: `14rz33a1b11p835xb5d4kyw0al2s77qyddhim859j06znhyy9m7h`
   - This is a Nix-specific base-32 encoded hash format

1. `hash`: `sha256-8NTkPbTfAJkKqhG25vE5WlAFuJ+kldXLQDeEFdQYP5M=`
   - This is a base-64 encoded hash with the prefix `sha256-`

For modern Nix usage (especially with flakes), you should use the `hash` field with the `sha256-` prefix intact. This format is called a "SRI hash" (Subresource Integrity hash) and is the preferred format in newer Nix code.

Usage in Nix configurations:

- For modern Nix with flakes, use the SRI hash format:

```nix
hash = "sha256-8NTkPbTfAJkKqhG25vE5WlAFuJ+kldXLQDeEFdQYP5M=";
```

- For older Nix functions that specifically require the `sha256` attribute, use the base-32 encoded value:

```nix
sha256 = "14rz33a1b11p835xb5d4kyw0al2s77qyddhim859j06znhyy9m7h";
```

The extension was initially set up with `lib.fakeSha256` as a placeholder value, and then this real hash was later substituted when the actual value was determined from the `nix-prefetch-git` command.

### Command Explanation

The hash was obtained using the following command:

```bash
nix-shell --packages nix-prefetch-git --run 'nix-prefetch-git --url https://github.com/isbecker/treefmt-vscode --rev e91d2246e1a1a684ac2065f329ed09fd6cc9dd08'
```

This command:

1. Starts a temporary `nix-shell` with the `nix-prefetch-git` tool installed
1. Uses `--run` to execute a command within that shell
1. Runs `nix-prefetch-git` with:
   - `--url` pointing to the GitHub repository
   - `--rev` specifying the exact commit hash to fetch
1. The command fetches the repository, calculates the hash, and outputs both the base-32 (`sha256`) and SRI format (`hash`) values
1. It also provides additional metadata like the commit date and path to the cached source

## 1970-01-01T01:00:00Z

### Initialize Journal

Initialized the project.
