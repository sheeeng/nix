# _: { }

{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # cargo # https://search.nixos.org/packages?channel=unstable&type=packages&show=cargo
    rustup # https://search.nixos.org/packages?channel=unstable&type=packages&show=rustup
  ];

  home.sessionVariables.RUSTUP_HOME = "${config.xdg.dataHome}/.rustup"; # https://rust-lang.github.io/rustup/configuration.html
}
