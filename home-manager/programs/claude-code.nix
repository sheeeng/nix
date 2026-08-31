{
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
  claudeCodeModel = "claude-sonnet-4-6"; # https://models.dev/models/anthropic/claude-sonnet-4-6/

  # Agents and commands that require OpenCode-specific permission enforcement
  # (permission: ask) and must not be exported to other runtimes that do not
  # translate or enforce that policy. The reviewer agents use OpenCode
  # tools/permission schema that Claude Code does not translate; exclude them
  # until a Claude-compatible read-only boundary is defined.
  openCodeOnlyAgents = [
    "associate-engineer-reviewer"
    "fix-agent"
    "penetration-engineer-reviewer"
    "senior-engineer-reviewer"
  ];
  openCodeOnlyCommands = [
    "fix"
    "implement"
  ];
  # Skills that depend on agents not exported to Claude Code. The implement
  # skill dispatches the three reviewer agents excluded above, so it must also
  # be excluded until those agents are supported here.
  openCodeOnlySkills = [ "implement" ];
in
{
  home.file.".claude/output-styles/Concise.md".source = ../llm/output-styles/Concise.md;

  home.packages =
    commonLlmSettings.packages
    ++ (with pkgs; [
      claude-mergetool # https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-mergetool
      claude-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-monitor
    ])
    ++ (pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) [
      pkgs.claude-usage-tracker # Native macOS menu bar app; only available on aarch64-darwin. https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-usage-tracker
    ]);

  programs.claude-code = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.enable
    enableMcpIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.enableMcpIntegration
    package = pkgs.claude-code; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.package
    agents = pkgs.lib.filterAttrs (
      name: _: !(builtins.elem name openCodeOnlyAgents)
    ) commonLlmSettings.agents; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.agents
    agentsDir = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.agentsDir
    commands = pkgs.lib.filterAttrs (
      name: _: !(builtins.elem name openCodeOnlyCommands)
    ) commonLlmSettings.commands; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.commands
    context = commonLlmSettings.context; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.context # Rendered to CLAUDE.md.
    skills = pkgs.lib.filterAttrs (
      name: _: !(builtins.elem name openCodeOnlySkills)
    ) commonLlmSettings.skills; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.skills
    mcpServers = {
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/";
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.mcpServers
    settings = {
      # https://code.claude.com/docs/en/settings#available-settings
      effortLevel = "medium"; # https://platform.claude.com/docs/en/build-with-claude/effort#effort-levels
      outputStyle = "Concise"; # https://code.claude.com/docs/en/output-styles
      # The attribution setting takes precedence over the deprecated includeCoAuthoredBy setting.
      # To hide all attribution, set commit and pr to empty strings and sessionUrl to false.
      # https://code.claude.com/docs/en/settings#attribution-settings
      attribution = {
        commit = "";
        pr = "";
        sessionUrl = false;
      }; # https://code.claude.com/docs/en/settings#attribution-settings
      includeCoAuthoredBy = false; # https://code.claude.com/docs/en/settings#attribution-settings (Deprecated)
      env = {
        # Compact sessions before they approach the context limit.
        # https://code.claude.com/docs/en/claude-code-on-the-web#manage-context
        CLAUDE_AUTOCOMPACT_PCT_OVERRIDE = "70";
        CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING = "1"; # Prevent Claude Code from dynamically overriding chosen thinking effort level.
        CLAUDE_CODE_DISABLE_AUTO_MEMORY = "1"; # Prevent automatically managed memory from retaining outdated information or inefficient processes.
        CLAUDE_CODE_SUBAGENT_MODEL = "sonnet"; # Use the efficient model for default subagents such as Explore.
      };
      hooks = commonLlmSettings.hooks // {
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
      model = claudeCodeModel;
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
      theme = "dark";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.settings
  };
}
