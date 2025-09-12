{ pkgs, ... }:
{
  programs.fzf = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enableFishIntegration
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enableZshIntegration
    package = pkgs.fzf; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.package
    changeDirWidgetCommand = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.changeDirWidgetCommand
    changeDirWidgetOptions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.changeDirWidgetOptions
    colors = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.colors
    defaultCommand = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.defaultCommand
    defaultOptions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.defaultOptions
    fileWidgetCommand = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.fileWidgetCommand
    fileWidgetOptions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.fileWidgetOptions
    historyWidgetOptions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.historyWidgetOptions
    tmux = {
      enableShellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.tmux.enableShellIntegration
      shellIntegrationOptions = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.tmux.shellIntegrationOptions
    };
  };

  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "${pkgs.findutils}/bin/find .";
    # FZF_DEFAULT_OPTS = "--height 40%"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
    FZF_CTRL_T_OPTS = "--preview '${pkgs.bat}/bin/bat --number --color=always --theme='Catppuccin Mocha' --line-range :500 {}'";
    FZF_ALT_C_OPTS = "--preview '${pkgs.eza}/bin/eza --tree --color=always {} | head -200'";
  };
}
