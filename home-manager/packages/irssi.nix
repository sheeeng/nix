{ ... }:
{
  programs.irssi = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.enable
    aliases = {
      irssi = "irssi";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.aliases
    extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.extraConfig
    networks = {
      liberachat = {
        autoCommands = [
          "/msg NickServ identify password"
        ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.autoCommands
        channels = {
          nixos = {
            autoJoin = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.channels._name_.autoJoin
          };
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.channels
        nick = "llee"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.nick
        saslExternal = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.saslExternal
        server = {
          address = "irc.libera.chat"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.server.address
          autoConnect = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.server.autoConnect
          port = 6697; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.server.port
          ssl = {
            enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.server.ssl.enable
            certificateFile = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.server.ssl.certificateFile
            verify = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks._name_.server.ssl.verify
          };
        };
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.networks
  };
}
