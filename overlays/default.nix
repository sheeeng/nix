# This file defines package overlays for the configuration
# See also 'stable-packages' and 'unstable-packages' overlays as mentioned in flake.nix
inputs: {
  # Add the unstable packages overlay
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  # SFMono Nerd Font Ligaturized
  sf-mono-liga = import ./sf-mono-liga.nix inputs;

  # Add other overlays here as needed
}
