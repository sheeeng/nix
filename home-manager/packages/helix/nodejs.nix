{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nodejs # temporarily disabled to skip Node.js tests
    # node2nix # temporarily disabled to skip Node.js tests
    # nodePackages_latest.npm-check-updates # temporarily disabled to skip Node.js tests
    # prefetch-npm-deps # temporarily disabled to skip Node.js tests
    # prefetch-yarn-deps # temporarily disabled to skip Node.js tests
    # yarn # temporarily disabled to skip Node.js tests
    # yarn2nix # temporarily disabled to skip Node.js tests
    # yarn-bash-completion # temporarily disabled to skip Node.js tests
    # zsh-better-npm-completion # temporarily disabled to skip Node.js tests
  ];

  programs.helix = {
    # extraPackages = with pkgs; [
    #   dockerfile-language-server-nodejs
    #   svelte-language-server
    #   tailwindcss-language-server
    #   vue-language-server
    # ]; # FIXME: error: collision between `/nix/store/jbympkpfxd2j2qnncsk5rfrkwr9xqpdx-helix-wrapped-24.07/bin/hx' and `/nix/store/k7qpx67xhgmkvvgb2fpwdy611cw98nx4-helix-24.07/bin/hx'
    languages = {
      language-server = { };
    };
  };
}
