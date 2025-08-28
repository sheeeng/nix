# https://github.com/RMTT/machines/blob/8a1d5a5c62e1e4e6b5e48184bc11960fce56fb24/home/modules/tmux.nix

{ pkgs, ... }:
{
  # programs.tmux.extraConfig = ''
  #   bind 0 set status
  #   bind S choose-session

  #   bind-key -r "<" swap-window -t -1
  #   bind-key -r ">" swap-window -t +1

  #   bind-key -n M-c run "tmux send-keys -t .+ C-\\\\ && tmux send-keys -t .+ C-a C-k C-l Up && tmux send-keys -t .+ Enter"
  #   bind-key -n M-r run "tmux send-keys -t .+ C-a C-k C-l Up && tmux send-keys -t .+ Enter"

  #   set -g pane-active-border-style fg=black
  #   set -g pane-border-style fg=black
  #   set -g status-bg black
  #   set -g status-fg white
  #   set -g status-right '#[fg=white]#(id -un)@#(hostname)   #(jq --raw-output '.darwinLabel' /run/current-system/darwin-version.json)'
  # '';
  # programs.tmux.aggressiveResize = true;
  # programs.tmux.clock24 = true;
  # programs.tmux.keyMode = "vi";
  # programs.tmux.terminal = "screen-256color";

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    clock24 = true;
    escapeTime = 0;
    extraConfig = ''
      set -s default-terminal 'screen-256color'

      unbind-key C-b
      set-option -g prefix C-x
      bind-key C-x send-prefix

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send -X cancel
      bind y run -b "\"\$TMUX_PROGRAM\" \''${TMUX_SOCKET:+-S \"\$TMUX_SOCKET\"} save-buffer - | wl-copy"

      bind -n M-H select-pane -L
      bind -n M-L select-pane -R
      bind -n M-K select-pane -U
      bind -n M-J select-pane -D

      bind -n M-P previous-window
      bind -n M-N next-window
    '';
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_status_modules_right "application session date_time"
        '';
      }
    ];
  };
}
