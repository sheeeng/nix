{
  lib,
  pkgs,
  ...
}:
{
  home.activation.configureKlipperPrivacy = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file klipperrc \
        --group General \
        --key IgnoreSelection \
        true

      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file klipperrc \
        --group General \
        --key KeepClipboardContents \
        false

      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file klipperrc \
        --group General \
        --key MaxClipItems \
        1

      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file klipperrc \
        --group General \
        --key NoEmptyClipboard \
        false
    ''
  );
}
