{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  commonLlmSettings = import ./default.nix {
    inherit pkgs;
    basePath = ./.;
    mattPocockSkillsSource = inputs.matt-pocock-skills;
  };

  # pi resolves keys that start with `!` as shell commands, so the key is read
  # from the sops-nix secret at runtime instead of being embedded in the Nix
  # store. https://pi.dev/docs/latest/providers#key-resolution
  piAuthSeed = pkgs.writeText "pi-auth.json" (
    builtins.toJSON {
      deepseek = {
        type = "api_key";
        key = "!cat ${config.sops.secrets."deepseek/api_key".path}";
      };
    }
  );
in
{
  # pi writes OAuth credentials to auth.json, so the file must stay writable.
  # Seed the DeepSeek credential once, then leave the file under pi control.
  # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation
  home.activation.seedPiAuth = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    authFile="${config.home.homeDirectory}/.pi/agent/auth.json"

    if [ -L "$authFile" ]; then
      run rm --force "$authFile"
    fi

    if [ ! -e "$authFile" ]; then
      run mkdir --parents "$(dirname "$authFile")"
      run install --mode=0600 ${piAuthSeed} "$authFile"
    fi
  '';

  programs.pi-coding-agent = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pi-coding-agent.enable
    package = pkgs.pi-coding-agent; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pi-coding-agent.package
    configDir = "${config.home.homeDirectory}/.pi/agent"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pi-coding-agent.configDir
    context = commonLlmSettings.context; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pi-coding-agent.context
    extraPackages = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pi-coding-agent.extraPackages
    keybindings = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pi-coding-agent.keybindings
    models = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pi-coding-agent.models
    settings = {
      compaction = {
        enabled = true;
        keepRecentTokens = 12000;
        modelOverrides = {
          "deepseek/deepseek-flash" = {
            keepRecentTokens = 8000;
            reserveTokens = 4096;
          };
        };
        reserveTokens = 8192;
      }; # https://pi.dev/docs/latest/settings#compaction
      defaultModel = "deepseek-flash"; # https://pi.dev/docs/latest/settings#model--thinking
      defaultProvider = "deepseek"; # https://pi.dev/docs/latest/settings#model--thinking
      defaultThinkingLevel = "medium"; # https://pi.dev/docs/latest/settings#model--thinking
      enableInstallTelemetry = false; # https://pi.dev/docs/latest/settings#telemetry-and-update-checks
      modelThinkingLevels = {
        "deepseek/deepseek-flash" = "low";
      }; # https://pi.dev/docs/latest/settings#model--thinking
      skills = [
        "~/.codex/skills"
      ];
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pi-coding-agent.settings
  };
}
