_:
let
  folderFiles = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));
  # Filter out files that are package derivations, not modules
  packageModuleFiles =
    dir:
    let
      excludedFiles = [ "download-nixos-iso.nix" ];
      allFiles = builtins.attrNames (builtins.readDir dir);
      filteredFiles = builtins.filter (fname: !(builtins.elem fname excludedFiles)) allFiles;
    in
    map (fname: dir + "/${fname}") filteredFiles;
in
{
  imports = [
    ./development.nix
    ./fonts.nix
    ./packages.nix
    ./programs.nix
    ./scripts.nix
    ./sops.nix
    ./theme.nix
  ]
  ++ (packageModuleFiles ./packages)
  ++ (folderFiles ./programs);
  # https://github.com/alexnabokikh/nix-config/blob/bddec40e097d4227cd95badfc02164aa006a8a4c/modules/home-manager/common/default.nix

  fonts.fontconfig.enable = true;
  # home.stateVersion = "25.11"; # Please read the comment before changing.

  # You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
  # This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`.
  nixpkgs.config.allowUnfree = true;

  home = {
    shell = {
      enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableBashIntegration
      enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableFishIntegration
      enableIonIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableIonIntegration
      enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableNushellIntegration
      enableShellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableShellIntegration
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableZshIntegration
    };
    shellAliases = {
      z = "zoxide";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.shellAliases
    stateVersion = "25.11"; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
  };
}
