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
  inherit superpowersSrc;
  inherit vercelSkillsSrc;

  packages = with pkgs; [
    pi-coding-agent # https://search.nixos.org/packages?channel=unstable&type=packages&show=pi-coding-agent
  ];

  agents = {
    # keep-sorted start
    builder = basePath + "/agents/builder.md";
    chicken = basePath + "/agents/chicken.md";
    code-reviewer = basePath + "/agents/code-reviewer.md";
    explorer = basePath + "/agents/explorer.md";
    planner = basePath + "/agents/planner.md";
    security-auditor = basePath + "/agents/security-auditor.md";
    superpowers-code-reviewer = "${superpowersSrc}/agents/code-reviewer.md";
    technical-writer = basePath + "/agents/technical-writer.md";
    # keep-sorted end
  };

  commands = {
    # keep-sorted start
    brainstorm = "${superpowersSrc}/commands/brainstorm.md";
    changelog = basePath + "/commands/changelog.md";
    commit = basePath + "/commands/commit.md";
    execute-plan = "${superpowersSrc}/commands/execute-plan.md";
    fix-issue = basePath + "/commands/fix-issue.md";
    implement = basePath + "/commands/implement.md";
    plan = basePath + "/commands/plan.md";
    pull-request = basePath + "/commands/pull-request.md";
    research = basePath + "/commands/research.md";
    write-plan = "${superpowersSrc}/commands/write-plan.md";
    # keep-sorted end
  };

  skills = {
    # keep-sorted start
    apply-owasp-security = basePath + "/skills/apply-owasp-security.md";
    fix-github-issue = basePath + "/skills/fix-github-issue.md";
    upsert-git-commit = basePath + "/skills/upsert-git-commit.md";
    upsert-github-pull-request = basePath + "/skills/upsert-github-pull-request.md";
    upsert-github-release = basePath + "/skills/upsert-github-release.md";
    # keep-sorted end
  };
}
