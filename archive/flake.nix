{
  # https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    pkgs = let
      inherit (inputs.nixpkgs) lib;
    in
      import inputs.nixpkgs {
        localSystem = {inherit system;};
        config = {
          allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              # List of unfree packages' names
            ];
        };
      };

    # Values required by Home-Manager
    username = "ubuntu"; # $USER
    system = "aarch64-darwin"; # x86_64-linux, aarch64-multiplatform, etc.
    stateVersion = "23.11"; # See https://nixos.org/manual/nixpkgs/stable for most recent
    homeDirectory = let
      homeDirPrefix =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/Users"
        else "/home";
    in "${homeDirPrefix}/${username}";
  in {
    homeConfigurations."ubuntu@machinename" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ({pkgs, ...}: {
          # Home-Manager must-haves
          home = {inherit username homeDirectory stateVersion;};
          # Always make the `home-manager` command available in environments controlled by HM
          home.packages = with pkgs; [home-manager];
        })

        # Structure your folder/file hierarchy however you want
        # import ./path-to-file.nix

        # For example
        # import ./home-manager/programs/cli/tmux.nix
      ];
    };
  };
}
