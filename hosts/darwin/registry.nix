_: { }

# { inputs, lib, ... }:
# let
#   # Adds/overrides all of the `nix registry list` references w/this flake's inputs
#   # NB: Does mean that referencing `inputs.nixpkgs.url = "nixpkgs";`
#   # from within this flake, will lead to recursive self-reference!
#   registry = inputs |> lib.mapAttrs (_: input: { flake = input; });
# in
# {
#   flake.modules.nixos.base.nix = { inherit registry; };
#   # flake.modules.systemConfig.base.nix = { inherit registry; };  # TODO: Not supported
#   flake.modules.homeManager.base.nix = { inherit registry; };
# }
