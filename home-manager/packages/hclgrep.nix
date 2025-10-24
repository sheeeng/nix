{ pkgs, ... }:
let
  hclgrep =
    with pkgs;
    buildGoModule {
      pname = "hclgrep";
      version = "00059cbc78022cab225e172cc695c5edf1e4b8ef";

      src = fetchFromGitHub {
        owner = "magodo";
        repo = "hclgrep";
        rev = "00059cbc78022cab225e172cc695c5edf1e4b8ef";
        hash = "sha256-OzY8QmOpJsfr3jYfzdamUMr9tIZPkuHtq9CfiCnVbAo="; # lib.fakeHash;
      };

      vendorHash = "sha256-Vk++UnfbKQMzM2uP+VwYVe9zgWhmBWckZ9oYF2Rfk0Q="; # lib.fakeHash;
    };
in
{
  home.packages = [ hclgrep ];
}
