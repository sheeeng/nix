{
  # https://opencode.ai/docs/formatters/
  css = {
    command = [
      "nix"
      "run"
      "nixpkgs#nodePackages.prettier"
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
      "nixpkgs#nodePackages.prettier"
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
      "nixpkgs#nodePackages.prettier"
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
      "nixpkgs#nodePackages.prettier"
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
      "nixpkgs#nodePackages.prettier"
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
      "nixpkgs#nodePackages.prettier"
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
    command = [
      "nix"
      "run"
      "nixpkgs#yamlfmt"
      "--"
      "$FILE"
    ];
    extensions = [
      ".yaml"
      ".yml"
    ];
  };
}
