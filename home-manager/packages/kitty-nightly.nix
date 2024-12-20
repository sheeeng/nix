_: { }

# # TODO: https://github.com/nix-community/home-manager/issues/6071#issuecomment-2494688917
# # kitty +list-fonts --psnames | grep "Nerd Font"
# # https://github.com/NixOS/nixpkgs/issues/86349
# # https://github.com/NixOS/nixpkgs/pull/225051/files
# # https://discourse.nixos.org/t/inconsistent-vendoring-in-buildgomodule-when-overriding-source/9225/6

# { pkgs, ... }:
# let
#   # pkgs = import <nixpkgs> {};
#   # myOverriddenPackage = pkgs.myPackage.overrideAttrs (oldAttrs: {

#   # https://github.com/NixOS/nixpkgs/blob/cf99465f46a5ccf4530e4ac23c79c7099b2dc6d7/pkgs/applications/terminal-emulators/kitty/default.nix
#   kitty-nightly = pkgs.kitty.overrideAttrs (oldAttrs: rec {
#     pname = "kitty-nightly"; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L37
#     version = "nightly"; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L38

#     src = pkgs.fetchFromGitHub {
#       owner = "kovidgoyal";
#       repo = "kitty";
#       rev = "refs/tags/${version}";
#       # If you don't know the hash for the first time, use `lib.faksHash` to get a fake hash.
#       # hash = lib.fakeHash;
#       # Then, nix will fail the build with an error message:
#       # error: hash mismatch in fixed-output derivation '/nix/store/mh23jmfszqbfpywbsnjzmv0bk3ygp3g0-source.drv':
#       #          specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
#       #             got:    sha256-ZglFhbRSCtTuh6mR4+cUMegagfSv9NzNty0zfU5x7Q8=
#       hash = "sha256-ZglFhbRSCtTuh6mR4+cUMegagfSv9NzNty0zfU5x7Q8=";
#     }; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L41

#     goModules =
#       (pkgs.buildGo123Module {
#         pname = "kitty-go-modules";
#         inherit src version;
#         vendorHash = "sha256-XWJuCfSYIP7zH1B0sUIvko7wp06s7pTc1gOuPJuwE6Q=";
#       }).goModules; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L48

#     buildPhase = (
#       oldAttrs.buildPhase
#       + ''
#         echo "Running extra commands in buildPhase..."
#       ''
#     );

#     # https://github.com/NixOS/nixpkgs/blob/c6ce9eaf37c240495d41d8e3b0cb5427e9f598c8/pkgs/applications/terminal-emulators/kitty/default.nix#L202-L243
#     postInstall = ''
#       echo "Running extra commands in postInstall..."
#       ${
#         if pkgs.stdenv.hostPlatform.isDarwin then
#           ''
#             # cp --recursive --verbose kitty.app "$out/Applications/kitty-nightly.app"
#             # ln --symbolic ../Applications/kitty-nightly.app/Contents/MacOS/kitty "$out/bin/kitty-nightly"

#             mv --verbose "$out/bin/kitty" "$out/bin/kitty-nightly"
#             mv --verbose "$out/bin/kitten" "$out/bin/kitten-nightly"
#             mv --verbose "$kitten/bin/kitten" "$kitten/bin/kitten-nightly"
#             mv --verbose "$out/Applications/kitty.app"  "$out/Applications/kitty-nightly.app"

#             echo "kitty-nightly is available at $out/bin/kitty-nightly"
#             # See https://github.com/kovidgoyal/kitty/pull/7970#issuecomment-2426591892.
#           ''
#         else
#           ''
#             # https://github.com/NixOS/nixpkgs/blob/c6ce9eaf37c240495d41d8e3b0cb5427e9f598c8/pkgs/applications/terminal-emulators/kitty/default.nix#L215
#           ''
#       }
#     '';
#   });
# in
# {
#   # If the derivation available in nixpkgs is out-of-date, use `overrideAttrs` to update the source locally.
#   # Install to either `environment.systemPackages` or `home.packages` depending on whether you want it available system-wide or to only a single user using home-manager.
#   # https://github.com/kovidgoyal/kitty/pull/7970
#   home.packages = [ kitty-nightly ];
# }

# # { pkgs, ... }:
# # let
# # in
# # version = "nightly";
# # kittyNightly = pkgs.kitty.overrideAttrs (oldAttrs: {
# #   src = pkgs.fetchFromGitHub {
# #     owner = "kovidgoyal";
# #     repo = "kitty";
# #     rev = "refs/tags/${version}";
# #     hash = "sha256-NvAwsGNmqVIMDmlMAnabh20e6pAXOaOxWuFfTpcSu/s=";
# #     # hash = "sha256-xxM5nqEr7avtJUlcsrA/KXOTxSajIg7kDQM6Q4V+6WM=";
# #     # rev = "4f6ca36bc202c64ed1730aa263d852b2b5a6ac3f";
# #     # hash = "sha256-NvAwsGNmqVIMDmlMAnabh20e6pAXOaOxWuFfTpcSu/s=";
# #     # TODO: GO MODULE DOES NOT WORK
# #     # >        golang.org/x/sys@v0.27.0: is explicitly required in go.mod, but not marked as explicit in vendor/modules.txt
# #     # >        golang.org/x/image@v0.21.0: is marked as explicit in vendor/modules.txt, but not explicitly required in go.mod
# #     # >        golang.org/x/sys@v0.26.0: is marked as explicit in vendor/modules.txt, but not explicitly required in go.mod
# #     # >
# #     # >        To ignore the vendor directory, use -mod=readonly or -mod=mod.
# #     # >        To sync the vendor directory, run:
# #     # >                go mod vendor
# #     # > Traceback (most recent call last):
# #   };
# # });
# # {
# # programs.kitty.package = kittyNightly;
# # }
