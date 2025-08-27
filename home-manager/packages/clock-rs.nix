{ pkgs, ... }:
{
  programs.clock-rs = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.clock-rs.enable
    package = pkgs.clock-rs; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.clock-rs.package
    settings = {
      general = {
        color = "magenta";
        interval = 250;
        blink = true;
        bold = true;
      };
      position = {
        horizontal = "start";
        vertical = "end";
      };
      date = {
        fmt = "%A, %B %d, %Y";
        use_12h = true;
        utc = true;
        hide_seconds = true;
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.clock-rs.settings
  };
}
