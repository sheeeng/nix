{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    lazygit.enable = true; # https://nix-community.github.io/nixvim/plugins/lazygit/index.html#pluginslazygitenable

    lint = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/lint/index.html#pluginslintenable
      lintersByFt = {
        text = [ "vale" ];
        json = [ "jsonlint" ];
        markdown = [ "vale" ];
        rst = [ "vale" ];
        ruby = [ "ruby" ];
        janet = [ "janet" ];
        inko = [ "inko" ];
        clojure = [ "clj-kondo" ];
        dockerfile = [ "hadolint" ];
        terraform = [ "tflint" ];
      };
    };

    lsp = {
      enable = true; # https://nix-community.github.io/nixvim/plugins/lsp/index.html#pluginslspenable
      package = pkgs.vimPlugins.nvim-lspconfig; # https://nix-community.github.io/nixvim/plugins/lsp/index.html#pluginslsppackage
      servers = {
        # Average webdev LSPs
        # astro.enable = true; # AstroJS
        # bashls.enable = true; # Bash
        # clangd.enable = true; # C/C++
        # csharp_ls.enable = true; # C#
        # cssls.enable = true; # CSS
        # dockerls.enable = true; # Docker
        # html.enable = true; # HTML
        # marksman.enable = true; # Markdown
        # nil_ls.enable = true; # Nix
        # phpactor.enable = true; # PHP
        # pyright.enable = true; # Python
        # svelte.enable = false; # Svelte
        # tailwindcss.enable = true; # TailwindCSS
        # ts_ls.enable = true; # TS/JS
        # vuels.enable = false; # Vue
        # yamlls.enable = true; # YAML

        lua_ls = {
          enable = true;
          settings.telemetry.enable = false;
        };

        # Rust
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
      };
    };

    lspkind = {
      enable = true;
      symbolMap = {
        Copilot = "";
      };
      extraOptions = {
        maxwidth = 50;
        ellipsis_char = "...";
      };
    };

    lualine.enable = true; # https://nix-community.github.io/nixvim/plugins/lualine/index.html#pluginslualineenable
  };
}
