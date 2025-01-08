# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ pkgs, ... }:
{
  programs.helix.languages = {
    language = [ ];

    language-server = {
      rust-analyzer = {
        command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        timeout = 120;
        config = {
          files = {
            excludeDirs = [ ".direnv" ];
            watcherExclude = [ ".direnv" ];
          };
          inlayHints = {
            bindingModeHints.enable = false;
            closingBraceHints.minLines = 10;
            closureReturnTypeHints.enable = "with_block";
            discriminantHints.enable = "fieldless";
            lifetimeElisionHints.enable = "skip_trivial";
            typeHints.hideClosureInitialization = false;
          };
          procMacro.enable = true;
          check = {
            allTargets = true;
            command = "clippy";
          };
        };
      };
    };
  };
}
