{ pkgs, ... }:
{
  programs.fish = {
    enable = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.enable
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
          rev = "26a50962bc68f5cb60fc488ee008b3d4d5be75f4";
          sha256 = "1q8vdjxnxn9b9dz7rqis9qirknsj95lmmsk34a3rvwsznsqprvp3";
          # nix run nixpkgs#nix-prefetch-git -- --url https://github.com/jethrokuan/z --rev 067e867debee59aee231e789fc4631f80fa5788e | jq --raw-output ".hash"
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.plugins._.src
      }
      {
        name = "fasd"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.plugins._.name
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-fasd";
          rev = "98c4c729780d8bd0a86031db7d51a97d55025cf5";
          sha256 = "0m0q0x66b498lxmma9l9qxpzfkms4g7mg26xb6kh2p55vil1547h";
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
