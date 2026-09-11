{
  config,
  lib,
  pkgs,
  ...
}:
let
  beadsDoltDirectory = "${config.home.homeDirectory}/github/sheeeng/nix/.beads/embeddeddolt/nix";
in
{
  home.activation.configureBeadsDoltIdentity = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${beadsDoltDirectory}/.dolt" ]; then
      (
        cd "${beadsDoltDirectory}"
        run ${lib.getExe pkgs.dolt} config --local --add user.email "305414+sheeeng@users.noreply.github.com"
        run ${lib.getExe pkgs.dolt} config --local --add user.name "Leonard Sheng Sheng Lee"
      )
    fi
  ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation

  home.file.".dolt/config_global.json".text = builtins.toJSON {
    "user.email" = "leonard.sheng.sheng.lee@gmail.com";
    "user.name" = "Leonard Sheng Sheng Lee";
  }; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
}
