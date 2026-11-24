{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start block=yes newline_separated=no
    brightnessctl
    pavucontrol
    pulseaudio
    wireplumber
    # keep-sorted end
  ];
}
