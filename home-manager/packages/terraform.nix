{ lib, pkgs, ... }:
let
  terraformVersion = lib.trim (builtins.readFile ../../.terraform-version);
  terraformTargets = {
    "aarch64-darwin" = "darwin_arm64";
    "aarch64-linux" = "linux_arm64";
    "x86_64-linux" = "linux_amd64";
  };
  terraformHashes = {
    "aarch64-darwin" = "sha256-8hARDFaYuU2AOnpjzbAlG1RVwVCEFHiAjiu7ND+V7Wg=";
    "aarch64-linux" = "sha256-iJHp3O3J47iVC8avnU2K8fTPreMGL1O53EA6ifbOjJw=";
    "x86_64-linux" = "sha256-0lzntpAgE62QXbPS6rC+TNkFiH/oi4GmFxuNVQPDHz0=";
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
      install --directory "$out/bin"
      install --mode 0755 terraform "$out/bin/terraform"
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
