# Download the official HashiCorp binary release instead of building from source.
# Building Terraform locally used to take 25+ minutes of CPU time per release
# because Windows Defender scans each compiled artifact during the build.
{ lib, pkgs }:
let
  terraformVersion = lib.trim (builtins.readFile ../.terraform-version);
  # Hashes are updated automatically by the update-terraform-binary-version
  # workflow. The workflow sed pattern matches lines indented with exactly four
  # spaces, so keep this attrset at four-space indentation and do not add any
  # other four-space-indented attrset with the same key names in this file.
  terraformHashes = {
    # keep-sorted start
    "aarch64-darwin" = "sha256-ik41D9GWTjpqp8LXeX1u1Ic1Z1pqTH8htDnIzLtQfMw=";
    "aarch64-linux" = "sha256-oMRylMORENNDvuXWxhmvu0OklQ4dAVk7gCySbjjUgZ8=";
    "x86_64-darwin" = "sha256-y51Uo2DBO/07GRRy9Z9QnQ1x9WC2UE+12Y+IAS+r368=";
    "x86_64-linux" = "sha256-gvjFsbvFER9p7eXUfiHxIQ9XvSN5Sh9yIYlXVFmN8zk=";
    # keep-sorted end
  };
  terraformSystem = pkgs.stdenv.hostPlatform.system;
  # Nested to avoid matching the workflow sed pattern (four-space indent).
  terraformPlatform =
    let
      platformMap = {
        "aarch64-darwin" = "darwin_arm64";
        "aarch64-linux" = "linux_arm64";
        "x86_64-darwin" = "darwin_amd64";
        "x86_64-linux" = "linux_amd64";
      };
    in
    platformMap.${terraformSystem};
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "terraform";
  version = terraformVersion;

  src = pkgs.fetchzip {
    url = "https://releases.hashicorp.com/terraform/${terraformVersion}/terraform_${terraformVersion}_${terraformPlatform}.zip";
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
    platforms = builtins.attrNames terraformHashes;
  };
}
