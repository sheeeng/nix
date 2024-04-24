# README

# x10an14's suggested Nix\* config

This repo contains a `flake.nix` whose outputs match the expected outputs required of:

- `sudo nixos-rebuild <switch|build|test|etc>`
- `home-manager <build|switch|etc>`

Originally the home-manager and nixos configs lived in separate repoes, but they started getting enough overlap to motivate me to combine them.

This repo may be forked somewhere, but the "true" source of truth resides over at [sourcehut](https://git.sr.ht/~x10an14/nix-configs).

### How to execute all tests

Below command can be run with only first three words, if nix-output-monitor (`nom`) is not installed for nice graphical terminal output.

```
nix flake check --log-format internal-json -v |& nom --json
```

## Home-Manager

TIP: "Install" by either (A) putting this repo into ~/.config/home-manager/,
or symlink it to wherever you've got it located so that the file `flake.nix` lies within that folder!!!

### How to update system

```
zi nix-configs
nix flake update
home-manager switch
```

Implicit in above command is the suffix `--flake ~/.config/nixpkgs#$USER@$(hostname)`.

#### How to test a build of system

```
home-manager build
```

##### How to test a build for a specific user/system combination

```
nix build .#homeConfigurations.$USER@$(hostname).activationPackage
```

```nix
{
  description = "Home Manager configuration";

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
```
