{ lib, pkgs, ... }:
{
  programs.fzf = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enableFishIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enableZshIntegration
    package = pkgs.fzf; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.package
    changeDirWidget = {
      command = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.changeDirWidget.command
      options = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.changeDirWidget.options
    };
    colors = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.colors
    defaultCommand = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.defaultCommand
    defaultOptions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.defaultOptions
    fileWidget = {
      command = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.fileWidget.command
      options = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.fileWidget.options
    };
    historyWidget = {
      options = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.historyWidget.options
    };
    tmux = {
      enableShellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.tmux.enableShellIntegration
      shellIntegrationOptions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.tmux.shellIntegrationOptions
    };
  };

  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "${lib.getExe' pkgs.findutils "find"} .";
    # FZF_DEFAULT_OPTS = "--height 40%"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
    FZF_CTRL_T_OPTS = "--preview '${lib.getExe pkgs.bat} --number --color=always --theme='Catppuccin Mocha' --line-range :500 {}'";
    FZF_ALT_C_OPTS = "--preview '${lib.getExe pkgs.eza} --tree --color=always {} | head -200'";
  };
}
