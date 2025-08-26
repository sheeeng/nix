# https://github.com/nix-community/fenix
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.fenix.packages.${pkgs.system}.latest.cargo
    inputs.fenix.packages.${pkgs.system}.latest.clippy
    inputs.fenix.packages.${pkgs.system}.latest.llvm-tools
    inputs.fenix.packages.${pkgs.system}.latest.miri
    inputs.fenix.packages.${pkgs.system}.latest.rust-analysis
    # inputs.fenix.packages.${pkgs.system}.latest.rust-analyzer # Temporarily disabled due to apple_sdk_11_0 issue
    pkgs.rust-analyzer # Use nixpkgs version instead
    inputs.fenix.packages.${pkgs.system}.latest.rust-docs
    inputs.fenix.packages.${pkgs.system}.latest.rust-src
    inputs.fenix.packages.${pkgs.system}.latest.rustc
    inputs.fenix.packages.${pkgs.system}.latest.rustc-codegen-cranelift
    inputs.fenix.packages.${pkgs.system}.latest.rustc-dev
    inputs.fenix.packages.${pkgs.system}.latest.rustfmt
    inputs.fenix.packages.${pkgs.system}.latest.toolchain
    # inputs.fenix.packages.${pkgs.system}.rust-analyzer-vscode-extension # Temporarily disabled due to apple_sdk_11_0 issue
  ];

  home.sessionVariables = {
    RUSTUP_HOME = "${config.xdg.dataHome}/.rustup"; # https://rust-lang.github.io/rustup/configuration.html
    CARGO_HOME = "${config.xdg.dataHome}/.cargo";
    RUST_SRC_PATH = "${
      inputs.fenix.packages.${pkgs.system}.latest.rust-src
    }/lib/rustlib/src/rust/library";
  };

  home.sessionPath = [
    "${config.xdg.dataHome}/.cargo/bin"
  ];
}
