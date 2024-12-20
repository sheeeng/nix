{ ... }:
{
  # programs.home-manager.enable = true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;
  programs.nix-index.enable = true;

  # services.sops-nix.enable = true;
}
