# https://github.com/maxhbr/myconfig/blob/f8ec80ed9eeb74b9931816f9188c9bd998b3d82f/hosts/host.f13/role.work/azure-cli.nix

{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    home-manager.sharedModules = [
      (
        let
          azure-cli-with-extensions =
            with pkgs;
            azure-cli.override {
              withExtensions = with azure-cli-extensions; [
                account
                aks-preview
                bastion
                ssh
              ];
            };
        in
        {
          home.packages = with pkgs; [ azure-cli-with-extensions ];
          home.file = {
            ".azure/config" = {
              text = ''
                [core]
                collect_telemetry = false
                only_show_errors = false

                [cloud]
                name = AzureCloud

                [extension]
                use_dynamic_install = false
                run_after_dynamic_install = false
              '';
            };
          };
        }
      )
    ];
  };
}
