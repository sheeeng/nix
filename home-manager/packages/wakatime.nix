_: { }

# {
#   config,
#   lib,
#   pkgs,
#   ...
# }:
# {
#   home.packages = with pkgs; [
#     wakatime-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=wakatime-cli
#   ];

#   home.sessionVariables = {
#     WAKATIME_API_KEY_FILE = config.sops.secrets."keys/wakatime".path;
#   };

#   home.activation.setupWakaTimeConfiguration = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
#     # If the script block produces any observable side effect, such as writing or deleting files, then it must be placed after the special writeBoundary script block.
#     # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation
#     # The script runs after `writeBoundary`, ensuring the secret is already decrypted and available to read.
#     $DRY_RUN_CMD mkdir --parents $VERBOSE_ARG ${config.home.homeDirectory}/.config/wakatime || true
#     if [ -f ${config.sops.secrets."keys/wakatime".path} ]; then
#       API_KEY=$(cat ${config.sops.secrets."keys/wakatime".path})
#       printf "[settings]\napi_key = %s\n" "$API_KEY" > ${config.home.homeDirectory}/.wakatime.cfg
#     fi
#   '';
# }
