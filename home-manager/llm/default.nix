{
  pkgs,
  basePath,
  mattPocockSkillsSource,
}:
let
  discoverDirectorySkills =
    skillsDir:
    pkgs.lib.mapAttrs' (name: _: pkgs.lib.nameValuePair name (skillsDir + "/${name}")) (
      pkgs.lib.filterAttrs (
        name: type: type == "directory" && builtins.pathExists (skillsDir + "/${name}/SKILL.md")
      ) (builtins.readDir skillsDir)
    );

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
  mattPocockSkills =
    discoverDirectorySkills (mattPocockSkillsSource + "/skills/engineering")
    // discoverDirectorySkills (mattPocockSkillsSource + "/skills/productivity");

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
  inherit superpowersSrc;
  inherit vercelSkillsSrc;

  # Shared global instructions rendered to each agent's user level rules file.
  # opencode renders this to AGENTS.md and claude-code renders it to CLAUDE.md.
  context = basePath + "/context.md";

  packages =
    with pkgs;
    [
      chatgpt-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=chatgpt-cli
      pi-coding-agent # https://search.nixos.org/packages?channel=unstable&type=packages&show=pi-coding-agent
    ]
    ++ pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) [
      chatgpt-desktop # https://search.nixos.org/packages?channel=unstable&type=packages&show=chatgpt-desktop
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
      localSkills =
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
          );
    in
    mattPocockSkills // localSkills;
}
