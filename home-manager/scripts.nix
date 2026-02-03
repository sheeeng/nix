{
  config,
  lib,
  pkgs,
  ...
}:
let

  shellScriptHeader = ''
    #!${pkgs.stdenv.shell}

    ## https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
    set -o pipefail # If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default.
    set -o errexit # set -e # Exit immediately if a pipeline, which may consist of a single simple command, a list, or a compound command returns a non-zero status.
    set -o nounset # set -u # Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’, or array variables subscripted with ‘@’ or ‘*’, as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit.
    # set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.

    ## https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
    shopt -s inherit_errexit # If set, command substitution inherits the value of the errexit option, instead of unsetting it in the subshell environment. This option is enabled when POSIX mode is enabled.

    echo $(${lib.getExe' pkgs.coreutils "date"} --universal --iso-8601=seconds)

  '';

  #  https://github.com/legendofmiracles/dotnix/blob/8dfa01af04d6391a1f5cb2c788bdecc1ee748ca9/hm/shell-scripts.nix

  build-my-live-iso = pkgs.writeScriptBin "build-my-live-iso" (
    "${shellScriptHeader}"
    + ''
      cd /tmp
      nix build /etc/nixos#nixosConfigurations.live-usb.config.system.build.isoImage
    ''
  );

  show-my-host = pkgs.writeScriptBin "show-my-host" (
    "${shellScriptHeader}"
    + ''
      OS_TYPE=$(uname -s)
      PUBLIC_IP=$(${lib.getExe pkgs.curl} --silent ifconfig.me)

      if [ "$OS_TYPE" = "Darwin" ]; then
        # macOS
        LOCAL_IP=$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
        CPU=$(sysctl -n machdep.cpu.brand_string)
        VIDEO=$(system_profiler SPDisplaysDataType 2>/dev/null | grep "Chipset Model" | sed 's/.*: //' | head -1)

        echo -e "Local: $LOCAL_IP, Public: $PUBLIC_IP\n"
        echo -e "Processor: $CPU"
        echo -e "Video: $VIDEO\n"

        echo -e "\nDisk Info:"
        diskutil list

        echo -e "\nLoaded Kernel Extensions (kexts):"
        kextstat | head -20
      else
        # Linux
        LOCAL_IP=$(${
          if pkgs.stdenv.isLinux then lib.getExe' pkgs.iproute2 "ip" else "ip"
        } -o addr show | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $4}' | cut -d'/' -f 1)
        CPU=$(sudo ${
          if pkgs.stdenv.isLinux then lib.getExe pkgs.lshw else "lshw"
        } -short 2>/dev/null | grep -i processor | sed 's/\s\s*/ /g' | cut -d' ' -f3-)
        VIDEO=$(${
          if pkgs.stdenv.isLinux then lib.getExe' pkgs.pciutils "lspci" else "lspci"
        } | grep -i 'vga\|3d\|2d' | cut -d' ' -f2-)

        echo -e "Local: $LOCAL_IP, Public: $PUBLIC_IP\n"
        echo -e "Processor: $CPU"
        echo -e "Video: $VIDEO\n"

        echo -e "\nDisk Info:"
        ${if pkgs.stdenv.isLinux then lib.getExe' pkgs.util-linux "lsblk" else "lsblk"} -f

        echo -e "\nKernel Modules (KVM):"
        ${
          if pkgs.stdenv.isLinux then lib.getExe' pkgs.kmod "lsmod" else "lsmod"
        } | ${lib.getExe pkgs.ripgrep} kvm || echo "No KVM modules loaded"
      fi
    ''
  );

  run-my-tmux = pkgs.writeScriptBin "run-my-tmux" (
    "${shellScriptHeader}"
    + ''
      if [ -z "$1" ]
        then
          ${lib.getExe pkgs.tmux} new -A -s 🦙
        else
          ${lib.getExe pkgs.tmux} new -A -s $1
      fi
    ''
  );
in
{
  # https://discourse.nixos.org/t/how-to-import-into-main-home-nix/55289/2
  home.packages = [
    build-my-live-iso
    show-my-host
    run-my-tmux

    (pkgs.writeShellScriptBin "say-my-hello" (
      "${shellScriptHeader}"
      + ''
        echo "Hello, ${config.home.username}!"
      ''
    ))

    (pkgs.writeShellScriptBin "run-my-cowsay" (
      "${shellScriptHeader}"
      + ''
        echo ''${PATH} | tr ':' '\n' \
          | ${lib.getExe pkgs.cowsay} -n -f small \
          | ${lib.getExe pkgs.lolcat} --animate --duration 1 --speed 512 --truecolor
        echo '----------------'
        echo \$\{PATH\} Items: $(echo ''${PATH} | tr ':' '\n' | wc --lines)
        echo '----------------'
      ''
    ))

    (pkgs.writeShellScriptBin "show-my-path" (
      "${shellScriptHeader}"
      + ''
        echo \$\{PATH\} Items: $(echo ''${PATH} | tr ':' '\n' | wc --lines)
        echo '----------------'
        echo ''${PATH} | tr ':' '\n'
        echo '----------------'
      ''
    ))

    (pkgs.writeShellScriptBin "show-my-colors" (
      "${shellScriptHeader}"
      + ''
        # https://unix.stackexchange.com/questions/60968/tmux-bottom-status-bar-color-change/60969#60969
        # https://unix.stackexchange.com/a/60969
        for i in {0..255} ; do
            printf "\x1b[38;5;%smColor%s\n" "''${i}" "''${i}"
        done
        echo '----------------'
      ''
    ))

    # Generate a UUID v5 (SHA-1 based) from a string argument.
    (pkgs.writeShellScriptBin "generate-my-uuid" (
      "${shellScriptHeader}"
      + ''
        if [ -z "''${1:-}" ]; then
          echo "Usage: generate-my-uuid <string>"
          echo "Generates a UUID v5 (SHA-1 based) from the input string using OID namespace."
          exit 1
        fi
        ${lib.getExe' pkgs.util-linux "uuidgen"} --sha1 --namespace @oid --name "$1"
      ''
    ))
  ];
}
