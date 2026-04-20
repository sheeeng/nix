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
      effortLevel = "high";
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
      model = "claude-3-5-sonnet-20241022";
      permissions = {
        additionalDirectories = [ "../docs/" ];
        allow = [
          "Bash(git diff:*)"
          "Edit"
        ];
        ask = [ "Bash(git push:*)" ];
        defaultMode = "acceptEdits";
        deny = [
          "WebFetch"
          "Bash(curl:*)"
          "Read(./.env)"
          "Read(./secrets/**)"
        ];
        disableBypassPermissionsMode = "disable";
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
