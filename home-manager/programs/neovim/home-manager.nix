{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fd # For nvim-telescope
    nixd # For nvim-lspconfig
    nodejs # Required for nvim-copilot
    typescript-language-server # For nvim-lspconfig
    ripgrep # For nvim-telescope and nvim-spectre
    terraform-ls # For nvim-lspconfig
    tree-sitter # For nvim-treesitter
    typescript # For nvim-lspconfig
    yaml-language-server # For nvim-lspconfig
  ];

  programs.neovim = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.enable
    package = pkgs.neovim-unwrapped; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.package
    autowrapRuntimeDeps = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.autowrapRuntimeDeps
    coc = {
      enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.coc.enable
      package = pkgs.vimPlugins.coc-nvim; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.coc.package
      pluginConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.coc.pluginConfig
      settings = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.coc.settings
    };
    defaultEditor = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.defaultEditor
    extraConfig = builtins.readFile ./vimrc; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraConfig
    extraLuaPackages = _ps: [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraLuaPackages
    extraName = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraName
    extraPackages = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraPackages
    extraPython3Packages = _ps: [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraPython3Packages
    extraWrapperArgs = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraWrapperArgs
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.finalPackage
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.generatedConfigViml
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.generatedConfigs
    initLua = builtins.readFile ./init.lua; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.initLua
    plugins =
      let
        cmp = with pkgs; [
          {
            plugin = vimPlugins.nvim-cmp;
            type = "lua";
            config = builtins.readFile ./plugins/nvim-cmp.lua;
          }
          vimPlugins.cmp-buffer
          vimPlugins.cmp-cmdline
          vimPlugins.cmp-nvim-lsp
          vimPlugins.cmp-path
          vimPlugins.cmp-vsnip
          vimPlugins.codex-nvim
          vimPlugins.nvim-cmp
          vimPlugins.vim-vsnip
        ];
        telescope = with pkgs; [
          {
            plugin = vimPlugins.telescope-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/telescope-nvim.lua;
          }
          vimPlugins.nvim-treesitter
        ];
        searchbox = with pkgs; [
          {
            plugin = vimPlugins.searchbox-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/searchbox-nvim.lua;
          }
          vimPlugins.nui-nvim
        ];
      in
      with pkgs;
      [
        { plugin = vimPlugins.diffview-nvim; } # https://search.nixos.org/packages?channel=unstable&type=packages&show=diffview-nvim
        {
          plugin = vimPlugins.copilot-vim;
          type = "lua";
          config = builtins.readFile ./plugins/copilot-vim.lua;
        }
        {
          plugin = vimPlugins.nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-tree-lua.lua;
        }
        {
          plugin = vimPlugins.nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-lspconfig.lua;
        }
        {
          plugin = vimPlugins.nvim-spectre; # https://github.com/NixOS/nixpkgs/issues/464899 is fixed upstream.
          type = "lua";
          config = builtins.readFile ./plugins/nvim-spectre.lua;
        }
        { plugin = vimPlugins.vim-visual-multi; }
        {
          plugin = vimPlugins.gitsigns-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/gitsigns-nvim.lua;
        }
      ]
      ++ pkgs.lib.optionals (pkgs.stdenv.system != "x86_64-darwin" && config.programs.aider-chat.enable) [
        { plugin = vimPlugins.aider-nvim; } # https://search.nixos.org/packages?channel=unstable&type=packages&show=aider-nvim
      ]
      ++ pkgs.lib.optionals (config.programs.opencode.enable) [
        { plugin = vimPlugins.opencode-nvim; } # https://search.nixos.org/packages?channel=unstable&type=packages&show=opencode-nvim
      ]
      ++ telescope
      ++ cmp
      ++ searchbox; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.plugins
    viAlias = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.viAlias
    vimAlias = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.vimAlias
    vimdiffAlias = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.vimdiffAlias
    withNodeJs = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.withNodeJs
    withPerl = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.withPerl
    withPython3 = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.withPython3
    withRuby = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.withRuby
  };
}
