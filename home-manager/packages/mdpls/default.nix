_: { }

# TODO: FIXME
# https://github.com/phR0ze/wmctl/blob/85027a732d0a3582a93a8295af2c5a381da26b91/pkg/wmctl.nix#L12
# https://github.com/llakala/nixos/blob/5dae1c83df4835fd23d433adc76f66bca44962ba/extras/packages/mdpls.nix

# TODO: error: function 'anonymous lambda' called with unexpected argument 'lib'?
# Did we include `{...}` in our lambda?

# {
#   pkgs,
#   ...
# }:
# let
#   mdpls = pkgs.rustPlatform.buildRustPackage rec {
#     pname = "mdpls";
#     version = "0-unstable";

#     src = pkgs.fetchFromGitHub {
#       owner = "euclio";
#       repo = "mdpls";
#       rev = "30761508593d85b5743ae39c4209947740eec92d";
#       sha256 = "sha256-4n1MX8hS7JmKzaL8GfMq2q3IdwE4fvMmWOYo7rY+cdY=";
#     };

#     cargoHash = "sha256-Cw2rofmAFnyce2BnWOP/NcoOshxMURjhfoxVT61R1lU=";

#     meta = {
#       description = "Markdown preview language server";
#       homepage = "";
#     };
#   };
# in
# {
#   home.packages = [
#     mdpls
#   ];
# }
