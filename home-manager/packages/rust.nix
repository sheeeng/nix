# https://github.com/nix-community/fenix
{
  config,
  pkgs,
  inputs,
  ...
}:
let
  cargoHome = "${config.xdg.dataHome}/.cargo";
in
{
  home.packages = [
    # Use individual components instead of the full toolchain to avoid conflicts
    inputs.fenix.packages.${pkgs.system}.latest.cargo
    inputs.fenix.packages.${pkgs.system}.latest.clippy
    inputs.fenix.packages.${pkgs.system}.latest.llvm-tools
    inputs.fenix.packages.${pkgs.system}.latest.miri
    inputs.fenix.packages.${pkgs.system}.latest.rust-analysis
    inputs.fenix.packages.${pkgs.system}.latest.rust-docs
    inputs.fenix.packages.${pkgs.system}.latest.rust-src
    inputs.fenix.packages.${pkgs.system}.latest.rustc
    inputs.fenix.packages.${pkgs.system}.latest.rustc-codegen-cranelift
    inputs.fenix.packages.${pkgs.system}.latest.rustc-dev
    inputs.fenix.packages.${pkgs.system}.latest.rustfmt
    # inputs.fenix.packages.${pkgs.system}.latest.toolchain # Disabled to avoid rust-analyzer conflicts

    pkgs.cabal-install # https://search.nixos.org/packages?channel=unstable&type=packages&show=cabal-install
    pkgs.ghc # https://search.nixos.org/packages?channel=unstable&type=packages&show=ghc
    pkgs.libiconv # https://search.nixos.org/packages?channel=unstable&type=packages&show=libiconv
    pkgs.rust-analyzer # TODO: # Use nixpkgs rust-analyzer to avoid apple_sdk_11_0 issue. # https://search.nixos.org/packages?channel=unstable&type=packages&show=rust-analyzer
    # inputs.fenix.packages.${pkgs.system}.latest.rust-analyzer # Temporarily disabled due to apple_sdk_11_0 issue
    # inputs.fenix.packages.${pkgs.system}.rust-analyzer-vscode-extension # Temporarily disabled due to apple_sdk_11_0 issue
  ];

  home.sessionVariables = {
    RUSTUP_HOME = "${config.xdg.dataHome}/.rustup"; # https://rust-lang.github.io/rustup/configuration.html
    CARGO_HOME = cargoHome;
    RUST_SRC_PATH = "${
      inputs.fenix.packages.${pkgs.system}.latest.rust-src
    }/lib/rustlib/src/rust/library";
  };

  home.sessionPath = [ "${cargoHome}/bin" ];

  home.file."${cargoHome}/config.toml".text = ''
    [target.aarch64-apple-darwin]
    rustflags = "-L${pkgs.libiconv}/lib";

    [target.x86_64-apple-darwin]
    rustflags = "-L${pkgs.libiconv}/lib";
  '';
}
