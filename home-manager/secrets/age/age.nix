# https://github.com/spikespaz/dotfiles/blob/c424772e21ff7751402e28f222543e74201a0ea1/secrets/secrets.nix
# https://github.com/ryantm/agenix/issues/50#issuecomment-1634714797

# https://github.com/ryantm/agenix/issues/50#issuecomment-2031401594
# ${config.xdg.dataHome} -> ${HOME}/.local/share
# ${config.xdg.configHome} -> ${HOME}/.config
# ${config.xdg.cacheHome} -> ${HOME}/.cache

# Create encrypted key file upon generation.
# age-keygen | age --passphrase > age-keys.age

# Create unencrypted key file.
# mkdir ~/.config/age
# age-keygen --output ~/.config/age/age-keys.txt
# age-keygen -y ~/.config/age/age-keys.txt
# age-keygen -y ~/.config/age/age-keys.txt > ~/.config/age/key.txt
# sed '/^AGE-SECRET-KEY/d' ~/.config/age/age-keys.txt > ~/.config/age/key.txt

# vim secrets/nix-configuration-github-token.txt
# age --armor \
#   --recipients-file ~/.ssh/id_ed25519.pub \
#   --recipients-file ~/.config/age/key.txt \
#   secrets/nix-configuration-github-token.txt \
#   > secrets/nix-configuration-github-token.age

# echo -n "CowardlyLion1939" > secrets/age/mock-passphrase.txt
# sudo age --armor \
#   --recipients-file /etc/ssh/ssh_host_ed25519_key.pub \
#   --recipients-file ~/.ssh/id_ed25519.pub \
#   --recipients-file ~/.config/age/key.txt \
#   secrets/age/mock-passphrase.txt \
#   > secrets/age/mock-passphrase.txt.age
# vi secrets/age/nix-configuration-github-token
# sudo age --armor --encrypt \
#   --recipients-file /etc/ssh/ssh_host_ed25519_key.pub \
#   --recipients-file ~/.ssh/id_ed25519.pub \
#   --recipients-file ~/.config/age/key.txt \
#   secrets/age/nix-configuration-github-token \
#   > secrets/age/nix-configuration-github-token.age

# curl --silent https://github.com/sheeeng.keys

# sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' -C "$(hostname)"
# sudo chmod 600 /etc/ssh/ssh_host_*
# sudo chown root:wheel /etc/ssh/ssh_host_*
# ls --long /etc/ssh/ssh_host_*
# sudo launchctl stop com.openssh.sshd
# sudo launchctl start com.openssh.sshd

{
  config,
  pkgs,
  # inputs,
  ...
}:
let
in
{
  # home.sessionPath = [
  #   "${pkgs.age}/bin"
  #   "${pkgs.rage}/bin"
  # ]; # Ensures `age` and `rage` included in the session path.

  # home.file = {
  #   ".ssh/age.key" = {
  #     source = "/Users/leonardlee/.config/age/age-keys.txt";
  #   };
  # };

  # home.sessionVariables.AGENIX_KEY = "/Users/leonardlee/.config/age/age-keys.txt"; # https://github.com/tedski999/dots/blob/ab2b24dd76920a449ea6e5527c9aaefe89359454/homes/tedj_work.nix#L105

  # https://github.com/tedski999/dots/blob/ab2b24dd76920a449ea6e5527c9aaefe89359454/homes/tedj_work.nix#L113
  age = {
    secrets = {
      "mock-passphrase.txt" = {
        file = ./mock-passphrase.txt.age; # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsnamefile
        # path = "${config.xdg.configHome}/mock-passphrase.txt"; # Defaults to /run/agenix/<name> or config.age.secretsDir/<name> directory. # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsnamepath
        # mode = ""; # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsnamemode
        # owner = ""; # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsnamegroup
        # group = ""; # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsnamegroup
        # symlink = true; # Defaults to true. # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsnamesymlink
        # name = "mock-passphrase"; # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsnamename
      };
      "nix-configuration-github-token" = {
        file = ./nix-configuration-github-token.age; # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsnamefile
      };
    }; # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecrets

    # ageBin = "${pkgs.age}/bin/age"; # https://github.com/ryantm/agenix?tab=readme-ov-file#ageagebin

    identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "${config.home.homeDirectory}/.ssh/id_ed25519"
    ]; # https://github.com/ryantm/agenix?tab=readme-ov-file#ageidentitypaths

    # https://github.com/ryantm/agenix/issues/50#issuecomment-1926893522
    secretsDir = "${config.home.homeDirectory}/.agenix/agenix"; # Defaults to /run/agenix directory. # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsdir
    secretsMountPoint = "${config.home.homeDirectory}/.agenix/agenix.d"; # Defaults to /run/agenix.d directory. # https://github.com/ryantm/agenix?tab=readme-ov-file#agesecretsmountpoint
  };

  home.packages = [
    pkgs.age
    pkgs.age-plugin-yubikey

    # (inputs.agenix.packages.${pkgs.system}.default.override {
    #   ageBin = "${pkgs.rage}/bin/rage"; # https://github.com/dsunshi/nixos-config/blob/fc4dab059eb9c3ce77f3c23d1077df444c41b98d/modules/agenix.nix#L14
    #   # plugins = pkgs.age-plugin-yubikey; # TODO: https://github.com/nixcafe/cattery-modules/blob/564c5ea73ae3e0a05677f152a0b27760678d8f54/modules/shared/secrets/default.nix#L169
    # }) # https://github.com/dsunshi/nixos-config/blob/fc4dab059eb9c3ce77f3c23d1077df444c41b98d/modules/agenix.nix#L13-L15

    (pkgs.writeShellScriptBin "echo-mock-passphrase" (''
      # "''${XDG_RUNTIME_DIR}"/''${dir} on linux or "''$(getconf DARWIN_USER_TEMP_DIR)"/''${dir} on darwin. # https://github.com/ryantm/agenix/blob/f6291c5935fdc4e0bef208cfc0dcab7e3f7a1c41/modules/age-home.nix#L154
      set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.
      ${pkgs.coreutils}/bin/cat ${config.age.secrets."mock-passphrase.txt".path}
      ${pkgs.coreutils}/bin/printf "\n%s\n" "--------"
      ${pkgs.bat}/bin/bat ${config.age.secrets."mock-passphrase.txt".path}
      set +o xtrace
    '')) # https://ajmasia.me/en/posts/2024/how-manage-secrets-in-nixos-using-sops-nix/#accessing-secrets-from-home-manager

    (pkgs.writeShellScriptBin "echo-nix-configuration-github-token" (''
      # "''${XDG_RUNTIME_DIR}"/''${dir} on linux or "''$(getconf DARWIN_USER_TEMP_DIR)"/''${dir} on darwin. # https://github.com/ryantm/agenix/blob/f6291c5935fdc4e0bef208cfc0dcab7e3f7a1c41/modules/age-home.nix#L154
      set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.
      ${pkgs.coreutils}/bin/cat ${config.age.secrets."nix-configuration-github-token".path}
      ${pkgs.coreutils}/bin/printf "\n%s\n" "--------"
      ${pkgs.bat}/bin/bat ${config.age.secrets."nix-configuration-github-token".path}
      set +o xtrace
    '')) # https://ajmasia.me/en/posts/2024/how-manage-secrets-in-nixos-using-sops-nix/#accessing-secrets-from-home-manager

  ];

}
