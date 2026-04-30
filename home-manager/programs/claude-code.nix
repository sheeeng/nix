{ pkgs, ... }:
let
  # obra/superpowers: A complete software development workflow for coding agents.
  # https://github.com/obra/superpowers
  superpowersSrc = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "v4.3.1"; # 151ac79ccac12d769356da93e6e0513ae736fa13
    hash = "sha256-/3T9haaI5x7wVLAy+z8NzaH5hI1qvIa2nTKq91jNNXA=";
  };
in
{
  home.packages =
    with pkgs;
    [
      claude-mergetool # https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-mergetool
      claude-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-monitor
    ]
    ++ (pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) [
      claude-usage-tracker # Native macOS menu bar app; only available on aarch64-darwin. https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-usage-tracker
    ]);

  programs.claude-code = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.enable
    enableMcpIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.enableMcpIntegration
    package = pkgs.claude-code; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.package
    agents = {
      builder = ./opencode/agents/builder.md;
      chicken = ./opencode/agents/chicken.md;
      code-reviewer = ./opencode/agents/code-reviewer.md;
      explorer = ./opencode/agents/explorer.md;
      planner = ./opencode/agents/planner.md;
      security-auditor = ./opencode/agents/security-auditor.md;
      superpowers-code-reviewer = "${superpowersSrc}/agents/code-reviewer.md";
      technical-writer = ./opencode/agents/technical-writer.md;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.agents
    agentsDir = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.agentsDir
    commands = {
      brainstorm = "${superpowersSrc}/commands/brainstorm.md";
      changelog = ./opencode/commands/changelog.md;
      commit = ./opencode/commands/commit.md;
      execute-plan = "${superpowersSrc}/commands/execute-plan.md";
      fix-issue = ./opencode/commands/fix-issue.md;
      implement = ./opencode/commands/implement.md;
      plan = ./opencode/commands/plan.md;
      research = ./opencode/commands/research.md;
      write-plan = "${superpowersSrc}/commands/write-plan.md";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.commands
    skills = {
      git-commit = ./opencode/skills/git-commit.md;
      git-release = ./opencode/skills/git-release.md;
      owasp-security = ./opencode/skills/owasp-security.md;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.skills
    mcpServers = {
      customTransport = {
        customOption = "value";
        timeout = 5000;
        type = "websocket";
        url = "wss://example.com/mcp";
      };
      database = {
        args = [
          "-y"
          "@bytebase/dbhub"
          "--dsn"
          "postgresql://user:pass@localhost:5432/db"
        ];
        command = "npx";
        env = {
          DATABASE_URL = "postgresql://user:pass@localhost:5432/db";
        };
        type = "stdio";
      };
      filesystem = {
        args = [
          "-y"
          "@modelcontextprotocol/server-filesystem"
          "/tmp"
        ];
        command = "npx";
        type = "stdio";
      };
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/";
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.mcpServers
    settings = {
      # https://code.claude.com/docs/en/settings#available-settings
      effortLevel = "high"; # https://platform.claude.com/docs/en/build-with-claude/effort#effort-levels
      env = {
        # https://x.com/kunchenguid/status/2043511416448307378
        CLAUDE_CODE_DISABLE_1M_CONTEXT = "1"; # Prevent bloated context window from degrading model performance and consuming token limits.
        CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING = "1"; # Prevent Claude Code from dynamically overriding chosen thinking effort level.
        CLAUDE_CODE_DISABLE_AUTO_MEMORY = "1"; # Prevent automatically managed memory from retaining outdated information or inefficient processes.
        CLAUDE_CODE_SUBAGENT_MODEL = "sonnet"; # Set to sonnet to ensure default subagents such as Explore perform adequately.
      };
      hooks = {
        PostToolUse = [
          {
            hooks = [
              {
                command = "nix fmt $(jq -r '.tool_input.file_path' <<< '$CLAUDE_TOOL_INPUT')";
                type = "command";
              }
            ];
            matcher = "Edit|MultiEdit|Write";
          }
        ];
        PreToolUse = [
          {
            hooks = [
              {
                command = "echo 'Running command: $CLAUDE_TOOL_INPUT'";
                type = "command";
              }
            ];
            matcher = "Bash";
          }
        ];
      };
      includeCoAuthoredBy = false;
      model = "claude-sonnet-4-6";
      permissions = {
        # https://code.claude.com/docs/en/permissions#wildcard-patterns
        additionalDirectories = [ "../docs/" ];
        allow = [
          "Bash(black *)"
          "Bash(cargo build *)"
          "Bash(cargo check *)"
          "Bash(cargo init *)"
          "Bash(cargo test *)"
          "Bash(cat *)"
          "Bash(docker images *)"
          "Bash(docker inspect *)"
          "Bash(docker logs *)"
          "Bash(docker ps *)"
          "Bash(docker version)"
          "Bash(eslint *)"
          "Bash(find *)"
          "Bash(gh issue list *)"
          "Bash(gh issue view *)"
          "Bash(gh pr checks *)"
          "Bash(gh pr diff *)"
          "Bash(gh pr list *)"
          "Bash(gh pr status)"
          "Bash(gh pr view *)"
          "Bash(gh release list *)"
          "Bash(gh repo view *)"
          "Bash(git branch *)"
          "Bash(git describe *)"
          "Bash(git diff *)"
          "Bash(git fetch *)"
          "Bash(git grep *)"
          "Bash(git log *)"
          "Bash(git ls-files *)"
          "Bash(git remote *)"
          "Bash(git rev-parse *)"
          "Bash(git shortlog *)"
          "Bash(git show *)"
          "Bash(git show-ref *)"
          "Bash(git status *)"
          "Bash(git tag *)"
          "Bash(git worktree list *)"
          "Bash(head *)"
          "Bash(isort *)"
          "Bash(kubectl config *)"
          "Bash(kubectl describe *)"
          "Bash(kubectl get *)"
          "Bash(kubectl logs *)"
          "Bash(kubectl version)"
          "Bash(node --version)"
          "Bash(npm --version)"
          "Bash(openspec instructions *)"
          "Bash(openspec new *)"
          "Bash(openspec status *)"
          "Bash(pip --version)"
          "Bash(pip list)"
          "Bash(pip show *)"
          "Bash(pre-commit run *)"
          "Bash(prettier *)"
          "Bash(python --version)"
          "Bash(python3 --version)"
          "Bash(ruff *)"
          "Bash(rustup default *)"
          "Bash(rustup show *)"
          "Bash(rustup target *)"
          "Bash(rustup toolchain *)"
          "Bash(tail *)"
          "Bash(terraform fmt *)"
          "Bash(terraform init *)"
          "Bash(terraform plan *)"
          "Bash(terraform show *)"
          "Bash(terraform validate *)"
          "Bash(terraform version)"
          "Bash(uv --version)"
          "Bash(uv pip list)"
          "Bash(vswhere *)"
          "PowerShell(cargo build *)"
          "Read(//c/Program Files \\(x86\\)/**)"
          "Read(//c/Program Files/**)"
          "WebFetch(domain:github.com)"
          "WebFetch(domain:raw.githubusercontent.com)"
          "WebFetch(domain:sheeeng.github.io)"
        ];
        ask = [
          "Bash(curl *)"
          "Bash(git add *)"
          "Bash(git commit *)"
          "Bash(git push *)"
          "Bash(wget *)"
        ];
        defaultMode = "acceptEdits";
        deny = [
          "Bash(curl *)"
          "Read(./.env)"
          "Read(./secrets/**)"
          "WebFetch"
        ];
        disableBypassPermissionsMode = "disable";
      };
      spinnerVerbs = {
        mode = "replace";
        verbs = [
          "Thinking"
          "思考中"
          "考える"
          "諗緊嘢"
        ];
      };
      statusLine = {
        command = "input=$(cat); echo \"[$(echo \"$input\" | jq -r '.model.display_name')] 📁 $(basename \"$(echo \"$input\" | jq -r '.workspace.current_dir')\")\"";
        padding = 0;
        type = "command";
      };
      theme = "dark";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.settings
  };
}
