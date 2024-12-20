{ pkgs, ... }:
let
  folderFiles = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));
in
{
  imports = (folderFiles ./plugins) ++ [
    ./keymaps.nix
    ./options.nix
  ];

  programs.nixvim = {
    enable = true; # https://nix-community.github.io/nixvim/platforms/hm.html#enable
    defaultEditor = true; # https://nix-community.github.io/nixvim/platforms/hm.html#defaulteditor
    vimdiffAlias = false; # https://nix-community.github.io/nixvim/platforms/hm.html#vimdiffalias

    enableMan = true; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#enableman
    package = pkgs.neovim-unwrapped; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#package

    colorschemes.catppuccin = {
      enable = true; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/index.html#colorschemescatppuccinenable
      package = pkgs.vimPlugins.catppuccin-nvim; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/index.html#colorschemescatppuccinpackage
      # luaConfig = {
      #   post = null; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/luaConfig.html#colorschemescatppuccinluaconfigpost
      #   pre = null; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/luaConfig.html#colorschemescatppuccinluaconfigpre
      # }; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/luaConfig.html#colorschemescatppuccinluaconfig
      # settings = {
      #   # Options provided to the require('catppuccin').setup function.
      #   compile_path = null; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingscompile_path
      #   custom_highlight = null; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingscustom_highlights
      #   default_integrations = true; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingsdefault_integrations
      #   flavour = "mocha"; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingsflavour
      #   integrations = {
      #     cmp = true;
      #     noice = true;
      #     notify = true;
      #     neotree = true;
      #     harpoon = true;
      #     gitsigns = true;
      #     which_key = true;
      #     illuminate.enabled = true;
      #     treesitter = true;
      #     treesitter_context = true;
      #     telescope.enabled = true;
      #     indent_blankline.enabled = true;
      #     mini.enabled = true;
      #     native_lsp = {
      #       enabled = true;
      #       inlay_hints = {
      #         background = true;
      #       };
      #       underlines = {
      #         errors = [ "underline" ];
      #         hints = [ "underline" ];
      #         information = [ "underline" ];
      #         warnings = [ "underline" ];
      #       };
      #     };
      #   }; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingsintegrations
      #   no_bold = false; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingsno_bold
      #   no_italic = false; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingsno_italic
      #   no_underline = false; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingsno_underline
      #   show_end_of_buffer = false; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingsshow_end_of_buffer
      #   term_colors = false; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingsterm_colors
      #   transparent_background = true; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html#colorschemescatppuccinsettingstransparent_background
      #   background = {
      #     dark = "mocha"; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/background.html#colorschemescatppuccinsettingsbackgrounddark
      #     light = "mocha"; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/background.html#colorschemescatppuccinsettingsbackgroundlight
      #   }; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/background.html
      # }; # https://nix-community.github.io/nixvim/colorschemes/catppuccin/settings/index.html
    }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#colorscheme

    diagnostics = {
      virtual_lines = {
        only_current_line = true;
      };
      virtual_text = false;
    }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#diagnostics

    extraPlugins = with pkgs.vimPlugins; [ vim-nix ]; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extrapackages

    opts = {
      # vim.opt.*
    }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#opts

    keymaps = [ ]; # https://nix-community.github.io/nixvim/keymaps/index.html#keymaps

    extraConfigLua = ''
      -- Set the listchars option to display trailing whitespace and the end of line character.
      -- https://github.com/nix-community/nixvim/issues/502#issue-1840186199
      vim.opt.listchars:append "eol:↴"
      -- Print a little welcome message when nvim is opened!
      print("Hello world!")
    ''; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraconfiglua
    extraConfigLuaPost = ""; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraconfigluapost
    extraConfigLuaPre = ""; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraconfigluapre
    extraConfigVim = ""; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraconfigvim
    # extraLuaPackages = ""; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extraluapackages
    extraPackages = [ ]; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extrapackages
    extraPython3Packages = p: with p; [ numpy ]; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#extrapython3packages

    files = {
      "ftplugin/nix.lua" = {
        opts = {
          expandtab = true;
          shiftwidth = 2;
          tabstop = 2;
        };
      };
    }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#files

    globalOpts = {
      # vim.opt_global.*
    }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#globalopts

    globals = {
      # vim.g.*
      mapleader = "<Space>";
      maplocalleader = "<Space>";
    }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#globals

    impureRtp = true; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#impurertp
    localOpts = {
      # vim.opt_local.*
    }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#localopts
    match = {
      ExtraWhitespace = "\\s\\+$";
    }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#match
    opts = {
      # vim.opt.*
    }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#opts
    path = ""; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#path
    # type = "lua"; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#type
    viAlias = true; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#vialias
    vimAlias = true; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#vimalias
    withNodeJs = false; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#withnodejs
    withPerl = false; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#withperl
    withPython3 = true; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#withpython3
    withRuby = true; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#withruby
    wrapRc = false; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#wraprc
  };
}
