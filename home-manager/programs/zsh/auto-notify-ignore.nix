_:
let
  default = [
    # keep-sorted start
    "git commit"
    "htop"
    "less"
    "man"
    "more"
    "nano"
    "nvim"
    "ssh"
    "tig"
    "top"
    "vim"
    "watch"
    # keep-sorted end
  ]; # https://github.com/MichaelAquilina/zsh-auto-notify/blob/b51c934d88868e56c1d55d0a2a36d559f21cb2ee/auto-notify.plugin.zsh#L23-L34
in
{
  # https://github.com/MichaelAquilina/zsh-auto-notify#configuration
  programs.zsh.localVariables = {
    AUTO_NOTIFY_EXPIRE_TIME = 5000; # https://github.com/MichaelAquilina/zsh-auto-notify/blob/b51c934d88868e56c1d55d0a2a36d559f21cb2ee/auto-notify.plugin.zsh#L5
    AUTO_NOTIFY_THRESHOLD = 30; # https://github.com/MichaelAquilina/zsh-auto-notify/blob/b51c934d88868e56c1d55d0a2a36d559f21cb2ee/auto-notify.plugin.zsh#L8
    AUTO_NOTIFY_TITLE = "AutoNotify: \"%command\" completed."; # https://github.com/MichaelAquilina/zsh-auto-notify/blob/b51c934d88868e56c1d55d0a2a36d559f21cb2ee/auto-notify.plugin.zsh#L63
    AUTO_NOTIFY_BODY = "AutoNotifyTotalTime: %elapsed\nExit code: %exit_code"; # https://github.com/MichaelAquilina/zsh-auto-notify/blob/b51c934d88868e56c1d55d0a2a36d559f21cb2ee/auto-notify.plugin.zsh#L64
    AUTO_NOTIFY_IGNORE = default ++ [
      # keep-sorted start
      "atuin"
      "claude"
      "emacs"
      "hx"
      "nix develop"
      "nix"
      "nix-shell"
      "opencode"
      "time"
      "vi"
      "vim"
      "watch"
      "yadm"
      # keep-sorted end
    ]; # https://github.com/MichaelAquilina/zsh-auto-notify/blob/b51c934d88868e56c1d55d0a2a36d559f21cb2ee/auto-notify.plugin.zsh#L22
  };
}
