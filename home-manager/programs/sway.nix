{ ... }:

{
  programs.swaylock.enable = true;

  home.file.".config/sway/config" = {
    text = ''
      # Sway WM Configuration - P14S
      # See man 5 sway for reference

      # Variables
      set $mod Mod4
      set $left h
      set $down j
      set $up k
      set $right l
      set $term alacritty
      set $menu rofi -show drun -theme DarkBlue

      set $ws1 "1"
      set $ws2 "2"
      set $ws3 "3"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10"

      # Output configuration
      # output * background /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill

      # Input configuration
      input "type:keyboard" {
          xkb_layout us
          xkb_variant ""
          xkb_options ""
      }

      input "type:pointer" {
          accel_profile flat
      }

      input "type:touchpad" {
          dwt enabled
          tap enabled
          natural_scroll enabled
          middle_emulation enabled
      }

      # Key bindings

      # Terminal
      bindsym $mod+Return exec $term
      bindsym $mod+Shift+Return exec $term -e tmux

      # Application launcher
      bindsym $mod+d exec $menu

      # Kill focused window
      bindsym $mod+Shift+q kill

      # Change focus
      bindsym $mod+$left focus left
      bindsym $mod+$down focus down
      bindsym $mod+$up focus up
      bindsym $mod+$right focus right

      # Move focused window
      bindsym $mod+Shift+$left move left
      bindsym $mod+Shift+$down move down
      bindsym $mod+Shift+$up move up
      bindsym $mod+Shift+$right move right

      # Split orientation
      bindsym $mod+b splith
      bindsym $mod+v splitv

      # Switch workspace
      bindsym $mod+1 workspace number $ws1
      bindsym $mod+2 workspace number $ws2
      bindsym $mod+3 workspace number $ws3
      bindsym $mod+4 workspace number $ws4
      bindsym $mod+5 workspace number $ws5
      bindsym $mod+6 workspace number $ws6
      bindsym $mod+7 workspace number $ws7
      bindsym $mod+8 workspace number $ws8
      bindsym $mod+9 workspace number $ws9
      bindsym $mod+0 workspace number $ws10

      # Move container to workspace
      bindsym $mod+Shift+1 move container to workspace number $ws1
      bindsym $mod+Shift+2 move container to workspace number $ws2
      bindsym $mod+Shift+3 move container to workspace number $ws3
      bindsym $mod+Shift+4 move container to workspace number $ws4
      bindsym $mod+Shift+5 move container to workspace number $ws5
      bindsym $mod+Shift+6 move container to workspace number $ws6
      bindsym $mod+Shift+7 move container to workspace number $ws7
      bindsym $mod+Shift+8 move container to workspace number $ws8
      bindsym $mod+Shift+9 move container to workspace number $ws9
      bindsym $mod+Shift+0 move container to workspace number $ws10

      # Layout
      bindsym $mod+w layout tabbed
      bindsym $mod+e layout toggle split
      bindsym $mod+s layout stacking
      bindsym $mod+f fullscreen toggle
      bindsym $mod+Shift+space floating toggle
      bindsym $mod+space focus mode_toggle

      # Parent container
      bindsym $mod+a focus parent

      # Scratchpad
      bindsym $mod+Shift+minus move scratchpad
      bindsym $mod+minus scratchpad show

      # Resize mode
      mode "resize" {
          bindsym $left resize shrink width 10px
          bindsym $down resize grow height 10px
          bindsym $up resize shrink height 10px
          bindsym $right resize grow width 10px

          bindsym Escape mode "default"
          bindsym Return mode "default"
      }

      bindsym $mod+r mode "resize"

      # Volume control
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle

      # Brightness control
      bindsym XF86MonBrightnessUp exec brightnessctl set +5%
      bindsym XF86MonBrightnessDown exec brightnessctl set 5%-

      # Screenshot
      bindsym Print exec grim -g "$(slurp)" - | wl-copy
      bindsym Shift+Print exec grim $(xdg-user-dir PICTURES)/screenshot-$(date +'%Y-%m-%d-%H%M%S').png

      # Lock screen
      bindsym $mod+l exec swaylock -f -c 000000

      # Reload config
      bindsym $mod+Shift+c reload

      # Exit Sway
      bindsym $mod+Shift+e exec swaynag -t warning -m 'Exit Sway?' -b 'Exit' 'swaymsg exit'

      # Status bar
      bar {
          position top
          status_command while date +'%Y-%m-%d %H:%M:%S'; do sleep 1; done
          colors {
              statusline #ffffff
              background #323232
              inactive_workspace #32323200 #323232 #5c5c5c
              active_workspace #32323200 #0088cc #ffffff
              focused_workspace #32323200 #0088cc #ffffff
          }
      }

      # Window rules
      for_window [app_id="floating_shell_on_top"] floating enable
      for_window [title="^Volume Control$"] floating enable

      # Autostart
      exec --no-startup-id swayidle -w \
          timeout 300 'swaylock -f -c 000000' \
          timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
          before-sleep 'swaylock -f -c 000000'

      exec mako
      exec waybar

      include /etc/sway/config.d/*
    '';
  };
}
