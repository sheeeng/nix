{ pkgs, ... }:
{
  programs.gh = {
    enable = true; # https://nix-community.github.io/home-manager/options/home-manager/programs/gh.html#opt-programs.gh.enable
    package = pkgs.gh; # https://nix-community.github.io/home-manager/options/home-manager/programs/gh.html#opt-programs.gh.package
    extensions = with pkgs; [
      # keep-sorted start
      gh-aw # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-aw
      gh-actions-cache # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-actions-cache
      gh-cal # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-cal
      gh-classroom # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-classroom
      gh-contribs # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-contribs
      gh-dash # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-dash
      gh-do # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-do
      gh-eco # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-eco
      gh-enhance # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-enhance
      gh-f # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-f
      gh-gei # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-gei
      gh-i # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-i
      gh-markdown-preview # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-markdown-preview
      gh-notify # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-notify
      gh-ost # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-ost
      gh-poi # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-poi
      gh-review-conductor # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-review-conductor
      gh-s # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-s
      gh-screensaver # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-screensaver
      gh-signoff # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-signoff
      gh-skyline # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-skyline
      gh-stack # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-stack
      gh-token # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-token
      gh-webhook # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-webhook
      github-copilot-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=github-copilot-cli
      # go-gonest # https://search.nixos.org/packages?channel=unstable&type=packages&show=go-gonest
      # keep-sorted end
    ]; # https://nix-community.github.io/home-manager/options/home-manager/programs/gh.html#opt-programs.gh.extensions

    gitCredentialHelper = {
      enable = true; # https://nix-community.github.io/home-manager/options/home-manager/programs/gh.html#opt-programs.gh.gitCredentialHelper.enable
      hosts = [
        "https://github.com"
        "https://gist.github.com"
      ]; # https://nix-community.github.io/home-manager/options/home-manager/programs/gh.html#opt-programs.gh.gitCredentialHelper.hosts
    };

    hosts = { }; # https://nix-community.github.io/home-manager/options/home-manager/programs/gh.html#opt-programs.gh.hosts

    settings = {
      editor = ""; # https://nix-community.github.io/home-manager/options/home-manager/programs/gh.html#opt-programs.gh.settings.editor
      git_protocol = "ssh"; # https://nix-community.github.io/home-manager/options/home-manager/programs/gh.html#opt-programs.gh.settings.git_protocol
    }; # https://nix-community.github.io/home-manager/options/home-manager/programs/gh.html#opt-programs.gh.settings
  };
}
