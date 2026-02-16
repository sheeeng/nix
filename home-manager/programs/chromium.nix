{ pkgs, ... }:
{
  programs.chromium = {
    enable = pkgs.stdenv.isLinux; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.chromium.enable
    package = pkgs.chromium; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.chromium.package
    # commandLineArgs = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.chromium.commandLineArgs
    # dictionaries = with pkgs.hunspellDicts; [
    #   en_US
    #   en_GB
    # ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.chromium.dictionaries
    # extensions = [
    #   { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
    #   { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    # ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.chromium.extensions
    # nativeMessagingHosts = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.chromium.nativeMessagingHosts
  };
}
