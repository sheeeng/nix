{ ... }:
{
  programs.dircolors = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.dircolors.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.dircolors.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.dircolors.enableFishIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.dircolors.enableZshIntegration
  };

  home.sessionVariables = {
    LS_COLORS = "di=1;35:ln=1;36:so=1;32:pi=1;33:ex=1;31:bd=1;34:cd=1;34:su=1;41:sg=1;46:tw=1;42:ow=1;43";
  };
}
