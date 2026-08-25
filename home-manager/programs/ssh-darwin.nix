{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    programs.ssh.settings = {
      "*".IgnoreUnknown = [ "UseKeychain" ]; # https://man.openbsd.org/ssh_config#IgnoreUnknown
      "*".UseKeychain = true; # https://man.openbsd.org/ssh_config#UseKeychain
      "github.com".IgnoreUnknown = [ "UseKeychain" ]; # https://man.openbsd.org/ssh_config#IgnoreUnknown
      "github.com".UseKeychain = true; # https://man.openbsd.org/ssh_config#UseKeychain
    };
  };
}
