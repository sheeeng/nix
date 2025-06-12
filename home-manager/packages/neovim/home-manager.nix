{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    fd # For nvim-telescope
    nixd # For nvim-lspconfig
    nodejs # Required for nvim-copilot
    nodePackages.typescript-language-server # For nvim-lspconfig
    ripgrep # For nvim-telescope and nvim-spectre
    terraform-ls # For nvim-lspconfig
    tree-sitter # For nvim-treesitter
    typescript # For nvim-lspconfig
    yaml-language-server # For nvim-lspconfig
  ];

  programs.neovim = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.enable
    package = pkgs.neovim-unwrapped; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.package
    defaultEditor = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.defaultEditor
    viAlias = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.viAlias
    vimAlias = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.vimAlias
    vimdiffAlias = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.vimdiffAlias
    extraConfig = builtins.readFile ./vimrc; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraConfig
    extraLuaConfig = builtins.readFile ./init.lua; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.extraLuaConfig
    withNodeJs = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.withNodeJs
    withPython3 = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.withPython3
    withRuby = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.withRuby
    plugins =
      let
        cmp = [
          {
            plugin = pkgs.vimPlugins.nvim-cmp;
            type = "lua";
            config = builtins.readFile ./plugins/nvim-cmp.lua;
          }
          pkgs.vimPlugins.cmp-buffer
          pkgs.vimPlugins.cmp-cmdline
          pkgs.vimPlugins.cmp-nvim-lsp
          pkgs.vimPlugins.cmp-path
          pkgs.vimPlugins.cmp-vsnip
          pkgs.vimPlugins.nvim-cmp
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
      [
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
        {
          plugin = pkgs.vimPlugins.gitsigns-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/gitsigns-nvim.lua;
        }
      ]
      ++ telescope
      ++ cmp
      ++ searchbox; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.plugins
  };
}
