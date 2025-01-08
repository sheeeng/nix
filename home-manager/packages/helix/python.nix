# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ pkgs, ... }:
{
  programs.helix.languages = {
    languages = [
      {
        name = "python";
        roots = [
          "pyproject.toml"
          "setup.py"
          "poetry.lock"
          "pyrightconfig.json"
          ".git"
        ];
        language-servers = [
          "pyright"
          "efm-python"
        ];
        auto-format = true;
        formatter = {
          command = "${pkgs.black}/bin/black";
          args = [
            "--quiet"
            "-"
          ];
        };
      }
    ];

    language-server = {
      pyright = {
        command = "pyright-langserver";
        args = [ "--stdio" ];
        config = {
          python.analysis = {
            autoSearchPaths = true;
            useLibraryCodeForTypes = true;
            diagnosticMode = "openFilesOnly";
          };
        };
      };
      efm-python = {
        command = "efm-langserver";
        config = {
          documentFormatting = true;
          languages.python = [
            {
              formatCommand = "black --quiet --line-length=100 -";
              formatStdin = true;
            }
            {
              formatCommand = "isort --profile google --line-length 100 --multi-line 3 --trailing-comma --use-parentheses --ensure-newline-before-comments --quiet -";
              formatStdin = true;
            }
          ];
        };
      };
    };
  };
}
