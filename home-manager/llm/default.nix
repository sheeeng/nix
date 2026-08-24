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

  renameSkill =
    {
      name,
      source,
    }:
    pkgs.runCommand name { } ''
      cp --recursive ${source} $out
      chmod --recursive u+w $out
      substituteInPlace $out/SKILL.md \
        --replace-fail "name: ${builtins.baseNameOf source}" "name: ${name}"
    '';

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

  # cathrynlavery/diagram-design: Technical and product diagram skill.
  # https://github.com/cathrynlavery/diagram-design
  diagramDesignSrc = pkgs.fetchFromGitHub {
    owner = "cathrynlavery";
    repo = "diagram-design";
    rev = "a157f7616473d966d6f433cf0b4d4f1880603504";
    hash = "sha256-tJVDM9Ujeu4mXLB6SHk62zxIJ0m+VqJu6xX7fJ8IwAo=";
  };

  designDiagramSkill = renameSkill {
    name = "design-diagram";
    source = diagramDesignSrc + "/skills/diagram-design";
  };

  # Fenng/Tech-Doc-Style-Chinese: Chinese technical writing style skill.
  # https://github.com/Fenng/Tech-Doc-Style-Chinese
  chineseWritingStyleSrc = pkgs.fetchFromGitHub {
    owner = "Fenng";
    repo = "Tech-Doc-Style-Chinese";
    rev = "a6f5b6064b92cac113e1277e5fbd266042e20577";
    hash = "sha256-4DFY9B5UERlwv883bjRbABYNdyZ12BWyDtGKanFQsEw=";
  };

  enforceChineseWritingStyleSkill = pkgs.runCommand "enforce-chinese-writing-style" { } ''
    mkdir $out
    cp ${chineseWritingStyleSrc}/LICENSE $out/LICENSE
    cp ${chineseWritingStyleSrc}/SKILL.md $out/SKILL.md
    cp --recursive ${chineseWritingStyleSrc}/agents $out/agents
    cp --recursive ${chineseWritingStyleSrc}/references $out/references
    chmod --recursive u+w $out
    substituteInPlace $out/SKILL.md \
      --replace-fail "name: tech-doc-style-chinese" "name: enforce-chinese-writing-style"
  '';

  # mattpocock/skills: Skills for real software engineering.
  # https://github.com/mattpocock/skills
  mattPocockSkills =
    discoverDirectorySkills (mattPocockSkillsSource + "/skills/engineering")
    // discoverDirectorySkills (mattPocockSkillsSource + "/skills/productivity");

  # Combined human writing editor and detector skill.
  # Sources:
  # * https://www.skills.sh/hardikpandya/stop-slop/stop-slop
  # * https://www.skills.sh/petergyang/no-ai-slop/no-ai-slop
  # * https://www.skills.sh/blader/humanizer
  # * https://www.skills.sh/cursor/plugins/unslop
  # * https://www.skills.sh/ehmo/slopkit/slopbeth
  # * https://www.skills.sh/aboudjem/humanizer-skill/humanizer
  # * https://www.skills.sh/stephenturner/skills/deslop
  # * https://www.skills.sh/elithrar/dotfiles/anti-slop
  # * https://www.skills.sh/aashaexo/soundshuman/humanize
  # * https://www.skills.sh/jalaalrd/anti-ai-slop-writing/anti-ai-slop-writing
  # Repository References:
  # * https://github.com/hardikpandya/stop-slop
  # * https://github.com/petergyang/no-ai-slop
  # * https://github.com/blader/humanizer
  # * https://github.com/ehmo/slopkit
  # * https://github.com/aboudjem/humanizer-skill
  # * https://github.com/stephenturner/skills
  # * https://github.com/elithrar/dotfiles/tree/main/.agents/skills/anti-slop
  # * https://github.com/aashaexo/soundshuman
  # * https://github.com/jalaalrd/anti-ai-slop-writing
  forbidLlmSlopSkill = basePath + "/skills/forbid-llm-slop";

  # vercel-labs/skills: Open agent skills ecosystem.
  # https://github.com/vercel-labs/skills
  vercelSkillsSrc = pkgs.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    rev = "v1.4.1"; # e00ad19cd60863bebbbd944a7035b42cfebd8bae
    hash = "sha256-6r9qCk96/1Ygrg2QuXUpZy5bPiCAO23GhPRqcg4hUQg=";
  };

  # DietrichGebert/ponytail: Minimal coding solutions.
  # https://github.com/DietrichGebert/ponytail
  ponytailSrc = pkgs.fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "0a4dd63ad4541f4f655c4108a295916f3c1d8fda";
    hash = "sha256-8cYggVltBAlZ/Zj4pl1bOu7mQdZFXCmDGW4RSpvRA+w=";
  };
in
{
  inherit anthropicSkillsSrc;
  inherit mattPocockSkills;
  inherit ponytailSrc;
  inherit superpowersSrc;
  inherit vercelSkillsSrc;

  # Shared global instructions rendered to each agent's user level rules file.
  # opencode renders this to AGENTS.md and claude-code renders it to CLAUDE.md.
  context = basePath + "/context.md";

  packages =
    with pkgs;
    [
      chatgpt-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=chatgpt-cli
      codex # https://search.nixos.org/packages?channel=unstable&type=packages&show=codex
      pi-coding-agent # https://search.nixos.org/packages?channel=unstable&type=packages&show=pi-coding-agent
    ]
    ++ pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) [
      chatgpt # https://search.nixos.org/packages?channel=unstable&type=packages&show=chatgpt
      codexbar # https://search.nixos.org/packages?channel=unstable&type=packages&show=codexbar
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
    mattPocockSkills
    // discoverDirectorySkills (ponytailSrc + "/skills")
    // localSkills
    // {
      design-diagram = designDiagramSkill;
      enforce-chinese-writing-style = enforceChineseWritingStyleSkill;
      forbid-llm-slop = forbidLlmSlopSkill;
    };
}
