{ pkgs, ... }:
{
  programs.helix = {
    # extraPackages = with pkgs; [
    #   python3 # https://search.nixos.org/packages?channel=unstable&type=packages&show=python3
    #   python3Packages.xlsxwriter # https://search.nixos.org/packages?channel=unstable&type=packages&show=python3-pyexcel-xlsxwriter
    #   python3Packages.xlrd # https://search.nixos.org/packages?channel=unstable&type=packages&show=python3-pyexcel-xls
    #   python3Packages.pyexcel-io # https://search.nixos.org/packages?channel=unstable&type=packages&show=python3-pyexcel-io
    #   python3Packages.pyexcel-xls # https://search.nixos.org/packages?channel=unstable&type=packages&show=python3-pyexcel-xls
    #   python3Packages.pyexcel-ods # https://search.nixos.org/packages?channel=unstable&type=packages&show=python3-pyexcel-ods
    #   python3Packages.pyexcel # https://search.nixos.org/packages?channel=unstable&type=packages&show=python3-pyexcel
    # ]; # FIXME: error: collision between `/nix/store/jbympkpfxd2j2qnncsk5rfrkwr9xqpdx-helix-wrapped-24.07/bin/hx' and `/nix/store/k7qpx67xhgmkvvgb2fpwdy611cw98nx4-helix-24.07/bin/hx'

    languages = {
      language = [
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
  };
}
