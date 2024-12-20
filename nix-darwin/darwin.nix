# https://github.com/carlthome/dotfiles/blob/714c86da15ef00bbd0882c8ca1afcced2ebf70fa/modules/nix-darwin/configuration.nix
{ pkgs, ... }:
{
  # The `home-manager` has issues adding applications to `~/Applications` directory.
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    kitty
    terminal-notifier
    clang
    coreutils
    findutils
    gcc-unwrapped
    git
    gnumake
    unixtools.watch
    vim
  ];

  # Enable fingerprint scanner for authentication.
  security.pam.enableSudoTouchIdAuth = true;

  # Let nix-darwin create /etc/* configs to load itself.
  # programs.fish.enable = true;
  # programs.bash.enable = true;
  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   enableSyntaxHighlighting = true;
  # };

  fonts.packages = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.package

  # Deduplicate files in the nix store.
  nix.optimise.automatic = true; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.optimise.automatic

  # Enable sandboxing.
  nix.settings.sandbox = false; # https://daiderd.com/nix-darwin/manual/index.html#opt-nix.settings.sandbox

  # Global shell aliases for all users.
  environment.shellAliases = {
    show-system = "nix derivation show /run/current-system";
    switch-system = "darwin-rebuild switch --flake .";
    list-generations = "nix-env --list-generations";
  }; # https://daiderd.com/nix-darwin/manual/index.html#opt-environment.shellAliases

  # Configure macOS settings.
  system.defaults = {
    trackpad = {
      ActuationStrength = 1; # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.trackpad.ActuationStrength
      Clicking = true; # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.trackpad.Clicking
    };
    dock = {
      autohide = false;
      autohide-delay = 0.24;
      autohide-time-modifier = 1.0;
      orientation = "bottom";
      show-process-indicators = true;
      show-recents = true;
      static-only = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    # Tab between form controls and F-row that behaves as F1-F12.
    # https://evantravers.com/articles/2024/02/06/switching-to-nix-darwin-and-flakes/
    # NSGlobalDomain = {
    #   AppleKeyboardUIMode = 3;
    #   "com.apple.keyboard.fnState" = true;
    # };
  };

  # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
  system.activationScripts.postUserActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
