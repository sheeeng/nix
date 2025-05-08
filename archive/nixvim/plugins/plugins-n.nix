{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    neo-tree = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html#pluginsneo-treeenable
      enableDiagnostics = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      closeIfLastWindow = true;
      popupBorderStyle = "rounded"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
      buffers = {
        bindToCwd = false;
        followCurrentFile = {
          enabled = true;
        };
      };
      window = {
        width = 40;
        height = 15;
        autoExpandWidth = false;
        mappings = {
          "<space>" = "none";
        };
      };
    }; # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html

    neoscroll.enable = true; # https://nix-community.github.io/nixvim/plugins/neoscroll/index.html#pluginsneoscrollenable

    nix = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/nix.html#pluginsnixenable
      package = pkgs.vimPlugins.vim-nix; # https://nix-community.github.io/nixvim/plugins/nix.html#pluginsnixpackage
    }; # https://nix-community.github.io/nixvim/plugins/nix.html

    noice.enable = true; # https://nix-community.github.io/nixvim/plugins/noice/index.html#pluginsnoiceenable

    none-ls = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/none-ls/index.html#pluginsnone-lsenable
      settings = {
        cmd = [ "bash -c nvim" ];
        debug = true;
      };
      sources = {
        code_actions = {
          statix.enable = true;
          gitsigns.enable = true;
        };
        diagnostics = {
          statix.enable = true;
          deadnix.enable = true;
          pylint.enable = true;
          checkstyle.enable = true;
        };
        formatting = {
          alejandra.enable = true;
          stylua.enable = true;
          shfmt.enable = true;
          nixpkgs_fmt.enable = true;
          google_java_format.enable = false;
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
          };
          black = {
            enable = true;
            settings = ''
              {
                extra_args = { "--fast" },
              }
            '';
          };
        };
        completion = {
          luasnip.enable = true;
          spell.enable = true;
        };
      };
    };

    notify = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/notify/index.html#pluginsnotifyenable
      backgroundColour = "#1e1e2e";
      fps = 60;
      render = "default";
      timeout = 500;
      topDown = true;
    };

    nvim-autopairs.enable = true; # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html#pluginsnvim-autopairsenable
  };
}
