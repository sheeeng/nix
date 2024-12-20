# https://github.com/spikespaz/dotfiles/blob/c424772e21ff7751402e28f222543e74201a0ea1/secrets/secrets.nix
# https://github.com/ryantm/agenix/issues/50#issuecomment-1634714797

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

# echo -n "CowardlyLion1939" > secrets/mock-passphrase.txt
# age --armor \
#   --recipients-file ~/.ssh/id_ed25519.pub \
#   --recipients-file ~/.config/age/key.txt \
#   secrets/mock-passphrase.txt \
#   > secrets/mock-passphrase.txt.age

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
  ...
}:
let
  currentDirectory = builtins.currentDirectory;
in
{
  home.file."currentDirectory.txt".text = "This file located in ${currentDirectory}.";

  home.packages = with pkgs; [
    sops

    (writeShellScriptBin "echo-example-key" (''
      set -o xtrace  # set -x # Print a trace of simple commands, for commands, case commands, select commands, and arithmetic for commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the PS4 variable is expanded and the resultant value is printed before the command and its expanded arguments.
      ${coreutils}/bin/cat ${config.sops.secrets.example_key.path}
      ${coreutils}/bin/printf "\n%s\n" "--------"
      ${bat}/bin/bat ${config.sops.secrets.example_key.path}
      set +o xtrace
    '')) # https://ajmasia.me/en/posts/2024/how-manage-secrets-in-nixos-using-sops-nix/#accessing-secrets-from-home-manager
  ];

  sops = {
    defaultSopsFile = ./example.yaml;
    defaultSopsFormat = "yaml";

    # Additionally secrets are symlinked to the users home at `$HOME/.config/sops-nix/secrets` which are referenced for the `.path` value in sops-nix.
    # https://github.com/Mic92/sops-nix/blob/2d73fc6ac4eba4b9a83d3cb8275096fbb7ab4004/README.md#L755
    # defaultSymlinkPath = "/run/user/1234/secrets"; # If the default is kept no other symlink is created. `%r` is replaced by $XDG_RUNTIME_DIR on linux or `getconf DARWIN_USER_TEMP_DIR` on darwin.

    # Additionally secrets are symlinked to the users home at `$HOME/.config/sops-nix/secrets` which are referenced for the `.path` value in sops-nix.
    # https://github.com/Mic92/sops-nix/blob/2d73fc6ac4eba4b9a83d3cb8275096fbb7ab4004/README.md#L754
    # defaultSecretsMountPoint = "/run/user/1234/secrets.d";

    # https://github.com/Mic92/sops-nix/blob/2d73fc6ac4eba4b9a83d3cb8275096fbb7ab4004/README.md#L756
    # This requires that the home-manager option `home.homeDirectory` is set to determine the home-directory on evaluation.  It will have to be manually set if home-manager is configured as stand-alone or on non NixOS systems.

    # gnupg = {
    #   home = "~/.gnupg";
    #   sshKeyPaths = [ ];
    # }; # https://ajmasia.me/en/posts/2024/how-manage-secrets-in-nixos-using-sops-nix/
    age = {
      # It's also possible to use a ssh key, but only when it has no password:
      # sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
      keyFile = "/Users/leonardlee/.config/sops/age/key.txt"; # must have no password!
      # keyFile = "/var/lib/sops-nix/key.txt";
      # sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # generateKey = false;
    };
    secrets = {
      example_key = {
        sopsFile = ./secrets/example.yaml;
        # hello = { };
        # example_key = { };
        # example_array = { };
        # example_number = { };
        # example_booleans = { };
        # github_token = { };
        # ssh_key = { };
        # mock_passphrase = { };
      };
      github_token = {
        sopsFile = ./secrets/users/leonardlee.yaml;
      };
    };
    # secrets.test = {
    #   # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

    #   # %r gets replaced with a runtime directory, use %% to specify a '%'
    #   # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
    #   # DARWIN_USER_TEMP_DIR) on darwin.
    #   path = "%r/test.txt";
    # };
  }; # https://ajmasia.me/en/posts/2024/how-manage-secrets-in-nixos-using-sops-nix/#accessing-secrets-from-home-manager
}
