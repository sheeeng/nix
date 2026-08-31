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

  # Commands that require OpenCode-specific permission enforcement and must
  # not be exported to other runtimes.
  openCodeOnlyCommands = [ "fix" ];

  codexSkillFiles = pkgs.lib.mapAttrs' (
    name: source:
    if builtins.pathExists (source + "/SKILL.md") then
      pkgs.lib.nameValuePair ".codex/skills/${name}" { inherit source; }
    else
      pkgs.lib.nameValuePair ".codex/skills/${name}/SKILL.md" { inherit source; }
  ) commonLlmSettings.skills;

  codexPromptFiles =
    pkgs.lib.mapAttrs'
      (name: source: pkgs.lib.nameValuePair ".codex/prompts/${name}.md" { inherit source; })
      (
        pkgs.lib.filterAttrs (
          name: _: !(builtins.elem name openCodeOnlyCommands)
        ) commonLlmSettings.commands
      );

  # Nixpkgs dropped x86_64-darwin support, so the LLM tooling below no longer
  # evaluates on Intel Macs.
  codexEnabled = pkgs.stdenv.hostPlatform.system != "x86_64-darwin";
in
{
  # Guard each home.* leaf rather than the whole `home` attribute. Home Manager
  # resolves the pkgs module argument by first reading home.stateVersion, so the
  # keys under `home` must be known without forcing pkgs. Wrapping all of `home`
  # in an mkIf whose condition reads pkgs hides those keys behind the condition,
  # which forces pkgs before its shape is known and triggers infinite recursion.
  # The file, packages, and sessionVariables leaves do not feed pkgs resolution,
  # so gating them individually is safe. This mirrors the targets.darwin guard
  # in home.nix.
  home = {
    file = pkgs.lib.mkIf codexEnabled (
      codexSkillFiles
      // codexPromptFiles
      // {
        ".codex/AGENTS.md".source = commonLlmSettings.context;
      }
    );
    packages = pkgs.lib.mkIf codexEnabled commonLlmSettings.packages;
    sessionVariables = pkgs.lib.mkIf codexEnabled {
      CODEX_HOME = "${config.home.homeDirectory}/.codex";
    };
  };
}
