{
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    programs.ssh.settings."*".UseKeychain = true; # https://man.openbsd.org/ssh_config#UseKeychain
  };
}
