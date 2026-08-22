{ lib, pkgs, ... }:
let
  terraformVersion = lib.trim (builtins.readFile ../../.terraform-version);
  terraformTargets = {
    "aarch64-darwin" = "darwin_arm64";
    "aarch64-linux" = "linux_arm64";
    "x86_64-linux" = "linux_amd64";
  };
  terraformHashes = {
    "aarch64-darwin" = "sha256-G8qlMDO0mmCWGFwzo6r6yIwH+banVvOcw8mvhsXA6Vw=";
    "aarch64-linux" = "sha256-q16b2gw1FmsRayl0Gw6XTLIo2wPuz2jAydkqWvIcVBI=";
    "x86_64-linux" = "sha256-kVLGoEaoEyMljOfNSRTXP2Hn2sGd4uQOoXsM37wfarE=";
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
