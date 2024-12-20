{ config, pkgs, ... }:
let

  shellHeader = ''
    #!${pkgs.stdenv.shell}

    ## https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
    set -o pipefail # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default.
    set -o errexit # set -e # Exit immediately if a pipeline, which may consist of a single simple command, a list, or a compound command returns a non-zero status.
    set -o nounset # set -u # Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’, or array variables subscripted with ‘@’ or ‘*’, as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit.
    # set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.

    ## https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
    shopt -s inherit_errexit # If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment. This option is enabled when POSIX mode is enabled.

    echo $(date --universal --iso-8601=seconds)

  '';

  #  https://github.com/legendofmiracles/dotnix/blob/8dfa01af04d6391a1f5cb2c788bdecc1ee748ca9/hm/shell-scripts.nix

  my-build-live-iso = pkgs.writeScriptBin "my-build-live-iso" (
    "${shellHeader}"
    + ''
      cd /tmp
      nix build /etc/nixos#nixosConfigurations.live-usb.config.system.build.isoImage
    ''
  );

  my-host-info = pkgs.writeScriptBin "my-host-info" (
    "${shellHeader}"
    + ''
      LOCAL_IP=$(ip -o addr show | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $4}' | cut -d'/' -f 1)
      PUBLIC_IP=$(curl -s ifconfig.me)
      CPU=$(sudo lshw -short | grep -i processor | sed 's/\s\s*/ /g' | cut -d' ' -f3-)
      VIDEO=$(sudo lspci | grep -i --color 'vga\|3d\|2d' | cut -d' ' -f2-)

      echo -e "local: $LOCAL_IP, public: $PUBLIC_IP\n"
      echo -e "Processor: $CPU"
      echo -e "Video: $VIDEO\n"

      echo -e "\n"
      lsblk -f

      echo -e "\n"
      lsmod | rg kvm
    ''
  );

  my-tmux = pkgs.writeScriptBin "my-tmux" (
    "${shellHeader}"
    + ''
      if [ -z "$1" ]
        then
          tmux new -A -s 🦙
        else
          tmux new -A -s $1
      fi
    ''
  );
in
{
  # https://discourse.nixos.org/t/how-to-import-into-main-home-nix/55289/2
  home.packages = [
    my-build-live-iso
    my-host-info
    my-tmux

    (pkgs.writeShellScriptBin "my-hello" (
      "${shellHeader}"
      + ''
        echo "Hello, ${config.home.username}!"
      ''
    ))

    (pkgs.writeShellScriptBin "my-cowsay" (
      "${shellHeader}"
      + ''
        echo ''${PATH} | tr ':' '\n' \
          | ${pkgs.cowsay}/bin/cowsay -n -f small \
          | ${pkgs.lolcat}/bin/lolcat --animate --duration 1 --speed 512 --truecolor
        echo '----------------'
        echo \$\{PATH\} Items: $(echo ''${PATH} | tr ':' '\n' | wc --lines)
        echo '----------------'
      ''
    ))

    (pkgs.writeShellScriptBin "my-path" (
      "${shellHeader}"
      + ''
        echo \$\{PATH\} Items: $(echo ''${PATH} | tr ':' '\n' | wc --lines)
        echo '----------------'
        echo ''${PATH} | tr ':' '\n'
        echo '----------------'
      ''
    ))

    (pkgs.writeShellScriptBin "my-colors" (
      "${shellHeader}"
      + ''
        # https://unix.stackexchange.com/questions/60968/tmux-bottom-status-bar-color-change/60969#60969
        # https://unix.stackexchange.com/a/60969
        for i in {0..255} ; do
            printf "\x1b[38;5;%smColor%s\n" "''${i}" "''${i}"
        done
        echo '----------------'
      ''
    ))
  ];
}
