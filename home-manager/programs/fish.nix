{ pkgs, ... }:
{
  programs.fish = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.enable
    package = pkgs.fish; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.package
    binds = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.binds
    functions = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.functions
    generateCompletions = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.generateCompletions
    interactiveShellInit = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.interactiveShellInit
    loginShellInit = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.loginShellInit
    plugins = [
      {
        name = "z"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.plugins._.name
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "067e867debee59aee231e789fc4631f80fa5788e";
          sha256 = "sha256-emmjTsqt8bdI5qpx1bAzhVACkg0MNB/uffaRjjeuFxU=";
          # nix run nixpkgs#nix-prefetch-git -- --url https://github.com/jethrokuan/z --rev 067e867debee59aee231e789fc4631f80fa5788e | jq --raw-output ".hash"
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.plugins._.src
      }
      {
        name = "fasd"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.plugins._.name
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-fasd";
          rev = "98c4c729780d8bd0a86031db7d51a97d55025cf5";
          sha256 = "sha256-8JASaNylXAGnWd2IV88juk73b8eJJlVrpyiRZUwHGFQ=";
          # nix run nixpkgs#nix-prefetch-git -- --url https://github.com/oh-my-fish/plugin-fasd --rev 98c4c729780d8bd0a86031db7d51a97d55025cf5 | jq --raw-output ".hash"
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.plugins._.src
      }
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.plugins
    preferAbbrs = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.preferAbbrs
    shellAbbrs = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.shellAbbrs
    shellInit = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.shellInit
    shellInitLast = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.shellInitLast
  };
}
