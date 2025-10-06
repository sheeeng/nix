{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # wakatime-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=wakatime-cli
  ];

  home.sessionVariables = {
    # TODO: WAKATIME_API_KEY
  };

  home.file = {
    ".wakatime.cfg" = {
      text = ''
        [settings]
        # TODO: api_key =
      '';
    };
  };
}
