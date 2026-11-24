{ pkgs, ... }:

{
  users.users.llee = {
    isNormalUser = true;
    description = "Leonard Lee";
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
