{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nodejs
    node2nix
    nodePackages_latest.npm-check-updates
    prefetch-npm-deps
    prefetch-yarn-deps
    yarn
    yarn2nix
    yarn-bash-completion
    zsh-better-npm-completion
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
