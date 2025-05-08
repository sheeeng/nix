# https://github.com/mufaroxyz/dotfiles/blob/249b67c429aa4d25016887d6c337ec5b6d355b46/modules/core/nixvim/options.nix

{ ... }:
{
  programs.nixvim.globalOpts = {
    # vim.opt_global.*

    # Line numbers
    number = true;
    relativenumber = true;

    # Always show the signcolumn, otherwise text would be shifted when displaying error icons
    signcolumn = "yes";

    # Search
    ignorecase = true;
    smartcase = true;

    # Tab defaults (might get overwritten by an LSP server)
    expandtab = true;
    shiftwidth = 4;
    smartindent = true;
    smarttab = true;
    softtabstop = 0;
    tabstop = 4;

    # System clipboard support, needs xclip/wl-clipboard
    clipboard = "unnamedplus";

    # Highlight the current line
    cursorline = true;

    # Show line and column when searching
    ruler = true;

    # Global substitution by default
    gdefault = true;

    # Start scrolling when the cursor is X lines away from the top/bottom
    scrolloff = 5;
  }; # https://nix-community.github.io/nixvim/NeovimOptions/index.html#globalopts
}
