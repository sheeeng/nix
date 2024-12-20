# https://github.com/japiirainen/darwin/blob/ccda9d41071e28db0c70f3e66ac220892ecd180d/home/helix.nix

{ ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      # theme = "catppuccin_macchiato"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.insert = {
        j = {
          k = "normal_mode";
        };
      };
    };
  };
}
