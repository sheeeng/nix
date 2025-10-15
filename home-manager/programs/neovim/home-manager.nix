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
    defaultEditor = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.defaultEditor
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
        {
          plugin = vimPlugins.diffview-nvim;
        }
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
          plugin = vimPlugins.nvim-spectre;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-spectre.lua;
        }
        {
          plugin = vimPlugins.vim-visual-multi;
        }
        {
          plugin = vimPlugins.gitsigns-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/gitsigns-nvim.lua;
        }
      ]
      ++ telescope
      ++ cmp
      ++ searchbox; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.plugins
  };
}
