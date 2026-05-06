{
  # https://opencode.ai/docs/formatters/
  css = {
    command = [
      "nix"
      "run"
      "nixpkgs#prettier"
      "--"
      "--parser"
      "css"
      "--write"
      "$FILE"
    ];
    extensions = [ ".css" ];
  };
  html = {
    command = [
      "nix"
      "run"
      "nixpkgs#prettier"
      "--"
      "--parser"
      "html"
      "--write"
      "$FILE"
    ];
    extensions = [ ".html" ];
  };
  javascript = {
    command = [
      "nix"
      "run"
      "nixpkgs#prettier"
      "--"
      "--parser"
      "babel"
      "--write"
      "$FILE"
    ];
    extensions = [
      ".js"
      ".jsx"
    ];
  };
  json = {
    command = [
      "nix"
      "run"
      "nixpkgs#prettier"
      "--"
      "--parser"
      "json"
      "--write"
      "$FILE"
    ];
    extensions = [
      ".json"
      ".jsonc"
    ];
  };
  markdown = {
    command = [
      "nix"
      "run"
      "nixpkgs#prettier"
      "--"
      "--parser"
      "markdown"
      "--write"
      "$FILE"
    ];
    extensions = [ ".md" ];
  };
  nix = {
    command = [
      "nix"
      "run"
      "nixpkgs#nixfmt"
      "--"
      "--indent"
      "2"
      "$FILE"
    ];
    extensions = [ ".nix" ];
  };
  python = {
    command = [
      "nix"
      "run"
      "nixpkgs#ruff"
      "--"
      "format"
      "$FILE"
    ];
    extensions = [
      ".py"
      ".pyi"
    ];
  };
  rust = {
    command = [
      "nix"
      "run"
      "nixpkgs#rustfmt"
      "--"
      "$FILE"
    ];
    extensions = [ ".rs" ];
  };
  shell = {
    command = [
      "nix"
      "run"
      "nixpkgs#shfmt"
      "--"
      "--indent"
      "2"
      "--write"
      "$FILE"
    ];
    extensions = [
      ".sh"
      ".bash"
      ".bats"
    ];
  };
  terraform = {
    command = [
      "nix"
      "run"
      "nixpkgs#opentofu"
      "--"
      "fmt"
      "$FILE"
    ];
    extensions = [
      ".tf"
      ".tfvars"
    ];
  };
  toml = {
    command = [
      "nix"
      "run"
      "nixpkgs#taplo"
      "--"
      "fmt"
      "$FILE"
    ];
    extensions = [ ".toml" ];
  };
  typescript = {
    command = [
      "nix"
      "run"
      "nixpkgs#prettier"
      "--"
      "--parser"
      "typescript"
      "--write"
      "$FILE"
    ];
    extensions = [
      ".ts"
      ".tsx"
    ];
  };
  yaml = {
    # @upstream-issue https://github.com/google/yamlfmt/issues/228#issuecomment-2538987870
    # @upstream-pull-request https://github.com/google/yamlfmt/pull/159
    # @upstream-pull-request https://github.com/google/yamlfmt/pull/98/changes
    command = [
      "nix"
      "run"
      "nixpkgs#yamlfmt"
      "--"
      "--formatter"
      (builtins.concatStringsSep "," [
        "disallow_anchors=false"
        "drop_merge_tag=false"
        "eof_newline=true"
        "include_document_start=false"
        "indent=2"
        "indentless_arrays=false"
        "line_ending=lf"
        "max_line_length=0"
        "pad_line_comments=1"
        "retain_line_breaks=true"
        "retain_line_breaks_single=true"
        "scan_folded_as_literal=true"
        "trim_trailing_whitespace=true"
      ])
      "$FILE"
    ];
    extensions = [
      ".yaml"
      ".yml"
    ];
  };
}
