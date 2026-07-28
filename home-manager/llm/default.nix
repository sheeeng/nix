{ pkgs, basePath }:
let
  # obra/superpowers: A complete software development workflow for coding agents.
  # https://github.com/obra/superpowers
  superpowersSrc = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "v4.3.1"; # 151ac79ccac12d769356da93e6e0513ae736fa13
    hash = "sha256-/3T9haaI5x7wVLAy+z8NzaH5hI1qvIa2nTKq91jNNXA=";
  };

  # anthropics/skills: Skills for Claude.
  # https://github.com/anthropics/skills
  anthropicSkillsSrc = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "3d59511518591fa82e6cfcf0438d68dd5dad3e76";
    hash = "sha256-mZZ0rlj/kju7we1h+MvUjgFAVjcZ/qKkMbNZfhfCSvk=";
  };

  # mattpocock/skills: Skills for real software engineering.
  # https://github.com/mattpocock/skills
  mattPocockSkillsSrc = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "2ab958093e83e0ec752e6c1c5932da465bf23e0c";
    hash = "sha256-dQtG6usJWlg/FqTajrjcs8GSdymH92WsgLiUaCfvKPA=";
  };

  mattPocockSkills = {
    # Engineering skills.
    ask-matt = "${mattPocockSkillsSrc}/skills/engineering/ask-matt";
    code-review = "${mattPocockSkillsSrc}/skills/engineering/code-review";
    codebase-design = "${mattPocockSkillsSrc}/skills/engineering/codebase-design";
    diagnosing-bugs = "${mattPocockSkillsSrc}/skills/engineering/diagnosing-bugs";
    domain-modeling = "${mattPocockSkillsSrc}/skills/engineering/domain-modeling";
    grill-with-docs = "${mattPocockSkillsSrc}/skills/engineering/grill-with-docs";
    implement = "${mattPocockSkillsSrc}/skills/engineering/implement";
    improve-codebase-architecture = "${mattPocockSkillsSrc}/skills/engineering/improve-codebase-architecture";
    prototype = "${mattPocockSkillsSrc}/skills/engineering/prototype";
    research = "${mattPocockSkillsSrc}/skills/engineering/research";
    resolving-merge-conflicts = "${mattPocockSkillsSrc}/skills/engineering/resolving-merge-conflicts";
    setup-matt-pocock-skills = "${mattPocockSkillsSrc}/skills/engineering/setup-matt-pocock-skills";
    tdd = "${mattPocockSkillsSrc}/skills/engineering/tdd";
    to-spec = "${mattPocockSkillsSrc}/skills/engineering/to-spec";
    to-tickets = "${mattPocockSkillsSrc}/skills/engineering/to-tickets";
    triage = "${mattPocockSkillsSrc}/skills/engineering/triage";
    wayfinder = "${mattPocockSkillsSrc}/skills/engineering/wayfinder";

    # Related productivity skills.
    grill-me = "${mattPocockSkillsSrc}/skills/productivity/grill-me";
    grilling = "${mattPocockSkillsSrc}/skills/productivity/grilling";
    handoff = "${mattPocockSkillsSrc}/skills/productivity/handoff";
    teach = "${mattPocockSkillsSrc}/skills/productivity/teach";
    writing-great-skills = "${mattPocockSkillsSrc}/skills/productivity/writing-great-skills";
  };

  # vercel-labs/skills: Open agent skills ecosystem.
  # https://github.com/vercel-labs/skills
  vercelSkillsSrc = pkgs.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    rev = "v1.4.1"; # e00ad19cd60863bebbbd944a7035b42cfebd8bae
    hash = "sha256-6r9qCk96/1Ygrg2QuXUpZy5bPiCAO23GhPRqcg4hUQg=";
  };
in
{
  inherit anthropicSkillsSrc;
  inherit mattPocockSkills;
  inherit mattPocockSkillsSrc;
  inherit superpowersSrc;
  inherit vercelSkillsSrc;

  packages = with pkgs; [
    pi-coding-agent # https://search.nixos.org/packages?channel=unstable&type=packages&show=pi-coding-agent
  ];

  agents =
    let
      agentsDir = basePath + "/agents";
    in
    pkgs.lib.mapAttrs'
      (name: _: pkgs.lib.nameValuePair (pkgs.lib.removeSuffix ".md" name) (agentsDir + "/${name}"))
      (
        pkgs.lib.filterAttrs (name: type: type == "regular" && pkgs.lib.hasSuffix ".md" name) (
          builtins.readDir agentsDir
        )
      )
    // {
      superpowers-code-reviewer = "${superpowersSrc}/agents/code-reviewer.md";
    };

  commands =
    let
      commandsDir = basePath + "/commands";
    in
    pkgs.lib.mapAttrs'
      (name: _: pkgs.lib.nameValuePair (pkgs.lib.removeSuffix ".md" name) (commandsDir + "/${name}"))
      (
        pkgs.lib.filterAttrs (name: type: type == "regular" && pkgs.lib.hasSuffix ".md" name) (
          builtins.readDir commandsDir
        )
      )
    // {
      brainstorm = "${superpowersSrc}/commands/brainstorm.md";
      execute-plan = "${superpowersSrc}/commands/execute-plan.md";
      write-plan = "${superpowersSrc}/commands/write-plan.md";
    };

  skills =
    let
      skillsDir = basePath + "/skills";
    in
    # Auto-discover both flat single-file skills (`<name>.md`) and directory
    # skills (`<name>/SKILL.md` plus optional `references/` for progressive
    # disclosure). The home-manager module renders a file to `<name>/SKILL.md`
    # and copies a directory recursively.
    pkgs.lib.mapAttrs'
      (
        name: type:
        if type == "directory" then
          pkgs.lib.nameValuePair name (skillsDir + "/${name}")
        else
          pkgs.lib.nameValuePair (pkgs.lib.removeSuffix ".md" name) (skillsDir + "/${name}")
      )
      (
        pkgs.lib.filterAttrs (
          name: type:
          (type == "regular" && pkgs.lib.hasSuffix ".md" name)
          || (type == "directory" && builtins.pathExists (skillsDir + "/${name}/SKILL.md"))
        ) (builtins.readDir skillsDir)
      )
    // mattPocockSkills;
}
