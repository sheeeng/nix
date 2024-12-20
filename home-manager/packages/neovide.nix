{ pkgs, ... }:
{
  # TODO: Enable on aarch64-darwin host platform only.
  # TODO: https://github.com/nix-community/home-manager/issues/6087
  programs.neovide = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovide.enable
    package = pkgs.neovide; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovide.package
    settings = {
      fork = false;
      frame = "full";
      idle = true;
      maximized = false;
      neovim-bin = "${pkgs.neovim}/bin/nvim";
      no-multigrid = false;
      srgb = false;
      tabs = true;
      theme = "auto";
      title-hidden = true;
      vsync = true;
      wsl = false;

      font = {
        normal = [ ];
        size = 14.0;
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovide.settings
  };
}
