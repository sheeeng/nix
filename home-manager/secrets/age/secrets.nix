{
  ...
}:
let
  # https://github.com/yaxitech/ragenix/blob/687ee92114bce9c4724376cf6b21235abe880bfa/example/secrets-configuration.nix
  usersPublicKeys = {
    agePublicKey = "age1vkqx0pc7t0afnjm7mkkt3ltfg39u3awzm26mg8sjcdtxna5gfuwqxvp5nh";
    sshEd25519PublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMBNfvwZvfv4fVKs+PXSLlqsFVkZqmA5m1X5FnWynkIA"; # cat ~/.ssh/id_ed25519.pub | pbcopy
  };
  systemsPublicKeys = {
    macBookProM2MaxPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKQHtJSC6ZZm0XASXF3kVeAH+mhjNOOOLvr7PzIknrD"; # sudo cat /etc/ssh/ssh_host_ed25519_key.pub | pbcopy
  };
  allUsersPublicKeys = builtins.attrValues usersPublicKeys;
  allSystemsPublicKeys = builtins.attrValues systemsPublicKeys;
in
{
  # imports =
  #   let
  #     commit = "f6291c5935fdc4e0bef208cfc0dcab7e3f7a1c41";
  #   in
  #   [
  #     "${
  #       builtins.fetchTarball {
  #         url = "https://github.com/ryantm/agenix/archive/${commit}.tar.gz";
  #         sha256 = "sha256:1x8nd8hvsq6mvzig122vprwigsr3z2skanig65haqswn7z7amsvg";
  #       }
  #     }/modules/age.nix"
  #   ];

  "mock-passphrase.txt".publicKeys = [
    allUsersPublicKeys
    allSystemsPublicKeys
  ]; # https://github.com/tedski999/dots/blob/ab2b24dd76920a449ea6e5527c9aaefe89359454/secrets/secrets.nix#L46
}
