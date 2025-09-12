{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    jnv # https://search.nixos.org/packages?channel=unstable&type=packages&show=jnv
    jql # https://search.nixos.org/packages?channel=unstable&type=packages&show=jql
    jqp # https://search.nixos.org/packages?channel=unstable&type=packages&show=jqp
  ];

  programs.helix = {
    # extraPackages = with pkgs; [
    #   tree-sitter-grammars.tree-sitter-json
    #   tree-sitter-grammars.tree-sitter-json5
    #   nodePackages_latest.vscode-json-languageserver
    # ]; # FIXME: error: collision between `/nix/store/jbympkpfxd2j2qnncsk5rfrkwr9xqpdx-helix-wrapped-24.07/bin/hx' and `/nix/store/k7qpx67xhgmkvvgb2fpwdy611cw98nx4-helix-24.07/bin/hx'
    languages = {
      language = [
        {
          name = "json";
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.fixjson; # https://search.nixos.org/packages?channel=unstable&type=packages&show=fixjson
          };
        }
      ];
      language-server = { };
    };
  };
}
