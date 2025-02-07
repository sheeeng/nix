{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = [
    pkgs.nodejs # Required for nvim-copilot
    pkgs.ripgrep # For nvim-telescope and nvim-spectre
    pkgs.fd # For nvim-telescope
    pkgs.tree-sitter # For nvim-treesitter
    pkgs.gcc-unwrapped # For nvim-lspconfig
    pkgs.typescript # For nvim-lspconfig
    pkgs.nixd # For nvim-lspconfig
    pkgs.nodePackages.typescript-language-server # For nvim-lspconfig
    pkgs.yaml-language-server # For nvim-lspconfig
    pkgs-unstable.terraform-ls # For nvim-lspconfig
  ];
  programs.neovim = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.enable
    package = pkgs.neovim-unwrapped; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.package
    coc = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.coc.enable
      package = pkgs.vimPlugins.coc-nvim; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.coc.package
      pluginConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.coc.pluginConfig
      settings = {
        "suggest.noselect" = true;
        "suggest.enablePreview" = true;
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.coc.settings
    };
    defaultEditor = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.defaulteditor
    extraConfig = builtins.readFile ./.vimrc; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraConfig
    extraLuaConfig = builtins.readFile ./init.lua; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraLuaConfig
    extraLuaPackages = luaPkgs: with luaPkgs; [ luautf8 ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraLuaPackages
    extraPackages = [ pkgs.shfmt ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraPackages
    extraPython3Packages =
      pyPkgs: with pyPkgs; [
        black
        python-lsp-server
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraPython3Packages
    extraWrapperArgs = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraWrapperArgs
    plugins =
      let
        cmp = [
          {
            plugin = pkgs.vimPlugins.nvim-cmp;
            type = "lua";
            config = builtins.readFile ./plugins/nvim-cmp.lua;
          }
          pkgs.vimPlugins.cmp-nvim-lsp
          pkgs.vimPlugins.cmp-buffer
          pkgs.vimPlugins.cmp-path
          pkgs.vimPlugins.cmp-cmdline
          pkgs.vimPlugins.nvim-cmp
          pkgs.vimPlugins.cmp-vsnip
          pkgs.vimPlugins.vim-vsnip
        ];
        telescope = [
          {
            plugin = pkgs.vimPlugins.telescope-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/telescope-nvim.lua;
          }
          pkgs.vimPlugins.nvim-treesitter
        ];
        searchbox = [
          {
            plugin = pkgs.vimPlugins.searchbox-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/searchbox-nvim.lua;
          }
          pkgs.vimPlugins.nui-nvim
        ];
      in
      [ ]
      ++ cmp
      ++ searchbox
      ++ telescope
      ++ [
        {
          plugin = pkgs.vimPlugins.diffview-nvim;
        }
        {
          plugin = pkgs.vimPlugins.copilot-vim;
          type = "lua";
          config = builtins.readFile ./plugins/copilot-vim.lua;
        }
        {
          plugin = pkgs.vimPlugins.nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-tree-lua.lua;
        }
        {
          plugin = pkgs.vimPlugins.nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-lspconfig.lua;
        }
        {
          plugin = pkgs.vimPlugins.nvim-spectre;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-spectre.lua;
        }
        {
          plugin = pkgs.vimPlugins.vim-visual-multi;
        }
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.plugins

    viAlias = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.viAlias
    vimAlias = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.vimAlias
    vimdiffAlias = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.vimdiffAlias
  };
}
