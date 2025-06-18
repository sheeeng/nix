{ pkgs, ... }:
{
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    home.packages = with pkgs; [
      sketchybar # https://search.nixos.org/packages?channel=unstable&type=packages&show=sketchybar
      sketchybar-app-font # https://search.nixos.org/packages?channel=unstable&type=packages&show=sketchybar-app-font
      sbarlua # https://search.nixos.org/packages?channel=unstable&type=packages&show=sbarlua
    ];

  ];
}
