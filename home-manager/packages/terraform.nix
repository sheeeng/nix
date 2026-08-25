{ lib, pkgs, ... }:
let
  terraformVersion = lib.trim (builtins.readFile ../../.terraform-version);
  terraformTargets = {
    "aarch64-darwin" = "darwin_arm64";
    "aarch64-linux" = "linux_arm64";
    "x86_64-linux" = "linux_amd64";
  };
  terraformHashes = {
    "aarch64-darwin" = "sha256-6vL3H5ahS0hHqf7gf6Kucj7d37hFykA3ssQ6ZjkjL18=";
    "aarch64-linux" = "sha256-MSkZXro8T5ZCT5TaxyGV0p88TpSHFzr6VQonOU63j0s=";
    "x86_64-linux" = "sha256-mVk/6fqQoI/ebJCSmKdDlk0OQiCAcNGNulMJ1jD2gL8=";
  };
  terraformSystem = pkgs.stdenv.hostPlatform.system;
  terraformBinary = pkgs.stdenvNoCC.mkDerivation {
    pname = "terraform";
    version = terraformVersion;

    src = pkgs.fetchzip {
      url = "https://releases.hashicorp.com/terraform/${terraformVersion}/terraform_${terraformVersion}_${
        terraformTargets.${terraformSystem}
      }.zip";
      hash = terraformHashes.${terraformSystem};
      stripRoot = false;
    };

    sourceRoot = ".";

    installPhase = ''
      ${lib.getExe' pkgs.coreutils "install"} --directory "$out/bin"
      ${lib.getExe' pkgs.coreutils "install"} --mode 0755 "$src/terraform" "$out/bin/terraform"
    '';

    meta = {
      description = "Infrastructure as code tool from the official HashiCorp binary release.";
      homepage = "https://www.terraform.io/";
      license = lib.licenses.bsl11;
      mainProgram = "terraform";
      platforms = builtins.attrNames terraformTargets;
    };
  };
in
{
  home.packages = lib.optionals (builtins.hasAttr terraformSystem terraformTargets) [
    terraformBinary
  ];
}
