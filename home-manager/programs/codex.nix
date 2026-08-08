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

  codexSkillFiles = pkgs.lib.mapAttrs' (
    name: source:
    if builtins.pathExists (source + "/SKILL.md") then
      pkgs.lib.nameValuePair ".codex/skills/${name}" { inherit source; }
    else
      pkgs.lib.nameValuePair ".codex/skills/${name}/SKILL.md" { inherit source; }
  ) commonLlmSettings.skills;
in
{
  home = {
    file = codexSkillFiles // {
      ".codex/AGENTS.md".source = commonLlmSettings.context;
    };
    packages = commonLlmSettings.packages;
    sessionVariables.CODEX_HOME = "${config.home.homeDirectory}/.codex";
  };
}
