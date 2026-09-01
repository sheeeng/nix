{ ... }:
{
  # Do not add UseKeychain here. UseKeychain is an Apple-specific SSH option
  # that Apple's bundled OpenSSH patch added in macOS Sierra. Nix installs
  # standard OpenSSH, which does not recognize the option and fails with
  # "Bad configuration option: usekeychain". The AddKeysToAgent setting in
  # the Host * block handles keychain integration on modern macOS.
  # https://developer.apple.com/library/archive/technotes/tn2449/_index.html
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.extraConfig
}
