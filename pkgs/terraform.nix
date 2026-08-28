# Download the official HashiCorp binary release instead of building from source.
# Building Terraform locally used to take 25+ minutes of CPU time per release
# because Windows Defender scans each compiled artifact during the build.
{ lib, pkgs }:
let
  terraformVersion = lib.trim (builtins.readFile ../.terraform-version);
  terraformTargets = {
    # keep-sorted start
    "aarch64-darwin" = "sha256-5HPwCmRdIusB9RDJa83qsqX9yObl4Mk1FfTa2xmvFXw=";
    "aarch64-linux" = "sha256-02Zhr59Qb4XKSdPUdo+yZXDKj0wa1mCdXy35JJB9ix4=";
    "x86_64-darwin" = "sha256-ouGntZN01Pro9tzu168Uz58SKs2eWziZZNtCEWStxXo=";
    "x86_64-linux" = "sha256-moAwCFJSNfNuYDMAQKat3sPXjf59Nm8Sphj64Tt2D5w=";
    # keep-sorted end
  };
  terraformHashes = {
    # keep-sorted start
    "aarch64-darwin" = "sha256-5HPwCmRdIusB9RDJa83qsqX9yObl4Mk1FfTa2xmvFXw=";
    "aarch64-linux" = "sha256-02Zhr59Qb4XKSdPUdo+yZXDKj0wa1mCdXy35JJB9ix4=";
    "x86_64-darwin" = "sha256-ouGntZN01Pro9tzu168Uz58SKs2eWziZZNtCEWStxXo=";
    "x86_64-linux" = "sha256-moAwCFJSNfNuYDMAQKat3sPXjf59Nm8Sphj64Tt2D5w=";
    # keep-sorted end
  };
  terraformSystem = pkgs.stdenv.hostPlatform.system;
in
pkgs.stdenvNoCC.mkDerivation {
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
}
