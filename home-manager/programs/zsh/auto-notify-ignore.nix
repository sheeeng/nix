_:
let
  default = [
    # keep-sorted start
    "vim"
    "nvim"
    "less"
    "more"
    "man"
    "tig"
    "watch"
    "git commit"
    "top"
    "htop"
    "ssh"
    "nano"
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
      "emacs"
      "hx"
      "nix develop"
      "nix-shell"
      "nix"
      "time"
      "yadm"
      # keep-sorted end
    ]; # https://github.com/MichaelAquilina/zsh-auto-notify/blob/b51c934d88868e56c1d55d0a2a36d559f21cb2ee/auto-notify.plugin.zsh#L22
  };
}
