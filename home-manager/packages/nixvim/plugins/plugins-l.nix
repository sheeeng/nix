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
        ts_ls.enable = true; # TS/JS
        cssls.enable = true; # CSS
        tailwindcss.enable = true; # TailwindCSS
        html.enable = true; # HTML
        astro.enable = true; # AstroJS
        phpactor.enable = true; # PHP
        svelte.enable = false; # Svelte
        vuels.enable = false; # Vue
        pyright.enable = true; # Python
        marksman.enable = true; # Markdown
        nil_ls.enable = true; # Nix
        dockerls.enable = true; # Docker
        bashls.enable = true; # Bash
        clangd.enable = true; # C/C++
        csharp_ls.enable = true; # C#
        yamlls.enable = true; # YAML

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
