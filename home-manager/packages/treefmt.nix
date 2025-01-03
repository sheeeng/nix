_: { }

# https://github.com/edgelesssys/contrast/blob/7c5206269d2ce0440090f05db601506011e2cd5f/treefmt.nix
# { lib, pkgs, ... }:
# {
#   projectRootFile = "flake.nix";
#   programs = {
#     # keep-sorted start block=true
#     actionlint.enable = true;
#     deadnix.enable = true;
#     formatjson5 = {
#       enable = true;
#       indent = 2;
#       oneElementLines = true;
#       sortArrays = true;
#     };
#     just.enable = true;
#     keep-sorted.enable = true;
#     nixfmt.enable = true;
#     shellcheck.enable = true;
#     shfmt.enable = true;
#     statix.enable = true;
#     terraform.enable = true;
#     # keep-sorted end
#   };
#   settings.formatter = {
#     addlicense = {
#       command = "${lib.getExe pkgs.addlicense}";
#       options = [
#         "-c=Acme Corporation"
#         "-s=only"
#         "-l=AGPL-3.0-only"
#       ];
#       includes = [
#         "*.go"
#         "*.nix"
#         "*.sh"
#       ];
#     };
#     vale = {
#       command = "${
#         pkgs.vale.withStyles (
#           s: with s; [
#             microsoft
#             google
#           ]
#         )
#       }/bin/vale";
#       options = [ "--no-wrap" ];
#       includes = [ "*.md" ];
#       excludes = [
#         "CODE_OF_CONDUCT.md"
#         "LICENSE"
#       ];
#     };
#     # TODO(katexochen): move back to programs after
#     # https://github.com/numtide/treefmt-nix/pull/193 is merged.
#     yamlfmt = {
#       command = "${lib.getExe pkgs.yamlfmt}";
#       options = [ "-formatter=retain_line_breaks_single=true" ];
#       includes = [
#         "*.yaml"
#         "*.yml"
#       ];
#     };
#   };
# }
