{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "${pkgs.findutils}/bin/find .";
    # FZF_DEFAULT_OPTS = "--height 40%"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
    FZF_CTRL_T_OPTS = "--preview '${pkgs.bat}/bin/bat --number --color=always --theme='Catppuccin Mocha' --line-range :500 {}'";
    FZF_ALT_C_OPTS = "--preview '${pkgs.eza}/bin/eza --tree --color=always {} | head -200'";
  };
}
