_: {
  # NixOS: https://search.nixos.org/options?channel=unstable&show=security.pki.caCertificateBlacklist
  # nix-darwin: https://nix-darwin.github.io/nix-darwin/manual/#opt-security.pki.caCertificateBlacklist
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
  ];
}
