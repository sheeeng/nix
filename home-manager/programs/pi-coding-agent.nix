{
  config,
  inputs,
  pkgs,
  ...
}:
let
  commonLlmSettings = import ../llm/default.nix {
    inherit pkgs;
    basePath = ../llm;
    mattPocockSkillsSource = inputs.matt-pocock-skills;
  };
in
{
  # The pi-coding-agent module has no auth.json option, so the DeepSeek API key
  # credential is written here. pi resolves keys that start with `!` as shell
  # commands, so the key is read from the sops-nix secret at runtime instead of
  # being embedded in this file or the Nix store.
  # https://pi.dev/docs/latest/providers#key-resolution
  home.file.".pi/agent/auth.json".text = builtins.toJSON {
    deepseek = {
      type = "api_key";
      key = "!cat ${config.sops.secrets."deepseek/api_key".path}";
    };
  };

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
