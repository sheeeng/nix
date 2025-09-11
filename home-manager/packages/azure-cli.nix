# https://github.com/maxhbr/myconfig/blob/f8ec80ed9eeb74b9931816f9188c9bd998b3d82f/hosts/host.f13/role.work/azure-cli.nix

_: { }

# {
#   pkgs,
#   ...
# }:
# {
#   home.packages = with pkgs; [
#     (azure-cli.override {
#       withImmutableConfig = false; # https://github.com/NixOS/nixpkgs/blob/17e6dae5f8e3753d4e4c6f489145f2a343f7ac72/pkgs/by-name/az/azure-cli/package.nix#L471-L473
#       withExtensions = with azure-cli-extensions; [
#         account # https://search.nixos.org/packages?channel=unstable&type=packages&show=azure-cli-extensions.account # https://github.com/azure/azure-cli-extensions/tree/main/src/account
#         aks-preview # https://search.nixos.org/packages?channel=unstable&type=packages&show=azure-cli-extensions.aks-preview # https://github.com/azure/azure-cli-extensions/tree/main/src/aks-preview
#         k8s-extension # https://search.nixos.org/packages?channel=unstable&type=packages&show=azure-cli-extensions.k8s-extension # https://github.com/azure/azure-cli-extensions/tree/main/src/k8s-extension
#         k8s-runtime # https://search.nixos.org/packages?channel=unstable&type=packages&show=azure-cli-extensions.k8s-runtime # https://github.com/azure/azure-cli-extensions/tree/main/src/k8s-runtime
#       ];
#     })
#   ];

# _: {
#   home.file = {
#     ".azure/config" = {
#       text = ''
#         [core]
#         collect_telemetry = false
#         only_show_errors = false

#         [cloud]
#         name = AzureCloud

#         [extension]
#         use_dynamic_install = false
#         run_after_dynamic_install = false
#       '';
#     };
#   };
# }
