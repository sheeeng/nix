{ pkgs, ... }:
let
  commonLlmSettings = import ../../llm/default.nix {
    inherit pkgs;
    basePath = ../../llm;
  };

  opencodeSuperpowersPlugin = "${commonLlmSettings.superpowersSrc}/.opencode/plugins/superpowers.js";

  opencodeModel = "github-copilot/gpt-5.6-sol"; # https://models.dev/models/openai/gpt-5.6-sol/
  opencodeSmallModel = "github-copilot/gpt-5.6-terra"; # https://models.dev/models/openai/gpt-5.6-terra/
in
{
  # Place superpowers plugin so OpenCode discovers it at startup.
  # The plugin injects the using-superpowers skill into the system prompt
  # via the experimental.chat.system.transform hook.
  xdg.configFile."opencode/plugins/superpowers.js" = {
    source = opencodeSuperpowersPlugin;
  };

  # Sets LLM_COAUTHOR so the prepare-commit-msg git hook injects the correct
  # Co-Authored-By trailer reflecting the active opencode model.
  home.shellAliases.opencode = "LLM_COAUTHOR=\"opencode (${opencodeModel}) <noreply@anthropic.com>\" ${pkgs.opencode}/bin/opencode";

  programs.opencode = {
    enable = pkgs.stdenv.system != "x86_64-darwin"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enable # Disabled on x86_64-darwin.
    enableMcpIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enableMcpIntegration
    package = pkgs.opencode; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.package
    agents = commonLlmSettings.agents; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.agents # https://opencode.ai/docs/agents/#markdown
    commands = commonLlmSettings.commands; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.commands # https://opencode.ai/docs/commands/#markdown
    context = commonLlmSettings.context; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.context
    tui = {
      theme = "opencode";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.tui
    settings = {
      agent = {
        build = {
          disable = true;
        };
        explore = {
          disable = true;
        };
        general = {
          disable = true;
        };
        plan = {
          disable = true;
        };
      }; # https://opencode.ai/docs/config/#agent
      default_agent = "planner"; # https://opencode.ai/docs/config/#default-agent
      model = opencodeModel; # https://models.dev/?search=github-copilot
      small_model = opencodeSmallModel; # https://models.dev/?search=github-copilot
      autoshare = false; # https://opencode.ai/docs/share/#auto-share
      autoupdate = true; # https://opencode.ai/docs/config/#autoupdate
      disabled_providers = [
        "deepseek"
        "xai"
        # https://opencode.ai/docs/providers/#directory
      ]; # https://opencode.ai/docs/config/#disabled-providers
      enabled_providers = [
        "amazon-bedrock"
        "anthropic"
        "github-copilot"
        "openai"
        # https://opencode.ai/docs/providers/#directory
      ]; # https://opencode.ai/docs/config/#enabled-providers
      permission = {
        # Read: Allow workspace, deny sensitive paths.
        read = {
          "*" = "allow";
          "*.env" = "deny";
          "*.env.*" = "deny";
          "*.env.example" = "allow";
          "~/.ssh/*" = "deny";
          "~/.gnupg/*" = "deny";
          "~/.aws/*" = "deny";
          "~/.config/gh/*" = "deny";
          "*credentials*" = "deny";
          "*secret*" = "deny";
          "*.pem" = "deny";
          "*.key" = "deny";
        };
        # Edit: Allow workspace, deny self-modification and sensitive configurations.
        edit = {
          "*" = "allow";
          ".opencode/opencode.jsonc" = "deny";
          ".opencode/*" = "deny";
          ".git/hooks/*" = "deny";
          "~/.bashrc" = "deny";
          "~/.bash_profile" = "deny";
          "~/.profile" = "deny";
          "~/.zshrc" = "deny";
          "~/.ssh/*" = "deny";
          "~/.gitconfig" = "deny";
          "~/.config/opencode/*" = "deny";
        };
        # Write: Same restrictions as edit.
        write = {
          "*" = "allow";
          ".opencode/opencode.jsonc" = "deny";
          ".opencode/*" = "deny";
          ".git/hooks/*" = "deny";
          "~/.bashrc" = "deny";
          "~/.bash_profile" = "deny";
          "~/.profile" = "deny";
          "~/.zshrc" = "deny";
          "~/.ssh/*" = "deny";
          "~/.gitconfig" = "deny";
          "~/.config/opencode/*" = "deny";
        };
        glob = "allow";
        grep = "allow";
        list = "allow";
        # Agent infrastructure.
        task = "ask";
        skill = "allow";
        lsp = "allow";
        todoread = "allow";
        todowrite = "allow";
        # Doom loop protection.
        doom_loop = "deny";
        # Network: Review URLs.
        webfetch = "ask";
        websearch = "ask";
        codesearch = "ask";
        # External directories: Allow skills, ask for everything else.
        external_directory = {
          "~/.config/opencode/*" = "allow";
          "*" = "ask";
        };
        # Bash: The main permission surface.
        # Strategy: Default to ask, then allow safe read-only development operations.
        # SRT wrappers are temporarily disabled. Permissions here are the primary control.
        # SRT-wrapped variants are kept for when sandboxing is re-enabled.
        # sandbox-runtime package: https://search.nixos.org/packages?channel=unstable&type=packages&show=sandbox-runtime
        # Rule order matters: OpenCode uses "last wins" semantics.
        # Put general rules first, specific exceptions after, dangerous denials last.
        bash = {
          # Default: Ask for any command not explicitly allowed.
          "*" = "ask";

          # Read-only shell utilities: Safe information gathering.
          "ls *" = "allow";
          "srt *'ls *" = "allow";
          "pwd" = "allow";
          "srt *'pwd'*" = "allow";
          "which *" = "allow";
          "srt *'which *" = "allow";
          "cat *" = "allow";
          "srt *'cat *" = "allow";
          "head *" = "allow";
          "srt *'head *" = "allow";
          "tail *" = "allow";
          "srt *'tail *" = "allow";
          "grep *" = "allow";
          "srt *'grep *" = "allow";
          "rg *" = "allow";
          "srt *'rg *" = "allow";
          "wc *" = "allow";
          "srt *'wc *" = "allow";
          "file *" = "allow";
          "srt *'file *" = "allow";
          "stat *" = "allow";
          "srt *'stat *" = "allow";
          "dirname *" = "allow";
          "srt *'dirname *" = "allow";
          "basename *" = "allow";
          "srt *'basename *" = "allow";
          "realpath *" = "allow";
          "srt *'realpath *" = "allow";
          "tree *" = "allow";
          "srt *'tree *" = "allow";
          "tree" = "allow";
          "srt *'tree'*" = "allow";
          "diff *" = "allow";
          "srt *'diff *" = "allow";
          "sort *" = "allow";
          "srt *'sort *" = "allow";
          "uniq *" = "allow";
          "srt *'uniq *" = "allow";
          "date *" = "allow";
          "srt *'date *" = "allow";
          "date" = "allow";
          "srt *'date'*" = "allow";
          "uname *" = "allow";
          "srt *'uname *" = "allow";
          "uname" = "allow";
          "srt *'uname'*" = "allow";

          # Potentially dangerous utilities: Require approval.
          # These can write files via redirection or execute via flags.
          "echo *" = "ask";
          "srt *'echo *" = "ask";
          "printf *" = "ask";
          "srt *'printf *" = "ask";
          "find *" = "ask";
          "srt *'find *" = "ask";
          "cp *" = "ask";
          "srt *'cp *" = "ask";
          "mv *" = "ask";
          "srt *'mv *" = "ask";

          # File management: Allow non-destructive operations.
          "mkdir *" = "allow";
          "srt *'mkdir *" = "allow";
          "touch *" = "allow";
          "srt *'touch *" = "allow";
          # rm: Only allow targeted removal. Do not allow recursive root or home removal.
          "rm *" = "allow";
          "srt *'rm *" = "allow";

          # Project tools: Build and query tools.
          "jq *" = "allow";
          "srt *'jq *" = "allow";
          "yq *" = "allow";
          "srt *'yq *" = "allow";

          # Nix tools: Allow safe inspection commands.
          "nix eval *" = "allow";
          "srt *'nix eval *" = "allow";
          "nix search *" = "allow";
          "srt *'nix search *" = "allow";
          "nix flake show*" = "allow";
          "srt *'nix flake show*" = "allow";
          "nix flake metadata*" = "allow";
          "srt *'nix flake metadata*" = "allow";
          "nix path-info *" = "allow";
          "srt *'nix path-info *" = "allow";
          "nix store path-info *" = "allow";
          "srt *'nix store path-info *" = "allow";
          "home-manager help" = "allow";
          "srt *'home-manager help'*" = "allow";
          "home-manager generations" = "allow";
          "srt *'home-manager generations'*" = "allow";
          "home-manager news" = "allow";
          "srt *'home-manager news'*" = "allow";

          # Nix tools: Require approval for mutating operations.
          "nix build *" = "ask";
          "srt *'nix build *" = "ask";
          "nix run *" = "ask";
          "srt *'nix run *" = "ask";
          "nix shell *" = "ask";
          "srt *'nix shell *" = "ask";
          "nix develop *" = "ask";
          "srt *'nix develop *" = "ask";
          "nix profile *" = "ask";
          "srt *'nix profile *" = "ask";
          "nix-env *" = "ask";
          "srt *'nix-env *" = "ask";
          "nix-collect-garbage*" = "ask";
          "srt *'nix-collect-garbage*" = "ask";
          "home-manager switch *" = "ask";
          "srt *'home-manager switch *" = "ask";
          "darwin-rebuild *" = "ask";
          "srt *'darwin-rebuild *" = "ask";
          "nixos-rebuild *" = "ask";
          "srt *'nixos-rebuild *" = "ask";

          # Homebrew commands are denied in this Nix-based environment.
          "brew *" = "deny";
          "srt *'brew *" = "deny";

          # Git: Allow read operations, ask for writes.
          "git status *" = "ask";
          "srt *'git status *" = "allow";
          "git status" = "ask";
          "srt *'git status'*" = "allow";
          "git diff *" = "allow";
          "srt *'git diff *" = "allow";
          "git diff" = "allow";
          "srt *'git diff'*" = "allow";
          "git log *" = "allow";
          "srt *'git log *" = "allow";
          "git log" = "allow";
          "srt *'git log'*" = "allow";
          "git show *" = "allow";
          "srt *'git show *" = "allow";
          "git branch *" = "allow";
          "srt *'git branch *" = "allow";
          "git branch" = "allow";
          "srt *'git branch'*" = "allow";
          "git rev-parse *" = "allow";
          "srt *'git rev-parse *" = "allow";
          "git ls-files *" = "allow";
          "srt *'git ls-files *" = "allow";
          "git ls-files" = "allow";
          "srt *'git ls-files'*" = "allow";
          "git blame *" = "allow";
          "srt *'git blame *" = "allow";
          "git stash list" = "allow";
          "srt *'git stash list'*" = "allow";
          "git remote -v" = "allow";
          "srt *'git remote -v'*" = "allow";
          "git tag *" = "allow";
          "srt *'git tag *" = "allow";
          "git tag" = "allow";
          "srt *'git tag'*" = "allow";
          "git add *" = "allow";
          "srt *'git add *" = "allow";
          "git commit *" = "allow";
          "srt *'git commit *" = "allow";
          "git checkout *" = "ask";
          "srt *'git checkout *" = "ask";
          "git switch *" = "ask";
          "srt *'git switch *" = "ask";
          "git merge *" = "ask";
          "srt *'git merge *" = "ask";
          "git rebase *" = "ask";
          "srt *'git rebase *" = "ask";
          "git push *" = "ask";
          "srt *'git push *" = "ask";
          "git pull *" = "ask";
          "srt *'git pull *" = "ask";

          # Beads: Issue tracking.
          "bd *" = "allow";
          "srt *'bd *" = "allow";
          "bd" = "allow";
          "srt *'bd'*" = "allow";
          "~/.local/bin/bd *" = "allow";
          "srt *'~/.local/bin/bd *" = "allow";
          "~/.local/bin/bd" = "allow";
          "srt *'~/.local/bin/bd'*" = "allow";

          # GitHub CLI: Allow read operations.
          "gh pr view *" = "allow";
          "srt *'gh pr view *" = "allow";
          "gh pr list *" = "allow";
          "srt *'gh pr list *" = "allow";
          "gh pr list" = "allow";
          "srt *'gh pr list'*" = "allow";
          "gh pr checks *" = "allow";
          "srt *'gh pr checks *" = "allow";
          "gh issue view *" = "allow";
          "srt *'gh issue view *" = "allow";
          "gh issue list *" = "allow";
          "srt *'gh issue list *" = "allow";
          "gh issue list" = "allow";
          "srt *'gh issue list'*" = "allow";
          "gh api *" = "ask";
          "srt *'gh api *" = "ask";
          "gh pr create *" = "ask";
          "srt *'gh pr create *" = "ask";
          "gh pr merge *" = "ask";
          "srt *'gh pr merge *" = "ask";

          # Dangerous patterns: Explicit denials for defense in depth.
          # These come last due to "last wins" rule order.

          # Subshell and interpreter execution. This is a bypass vector.
          "bash *" = "deny";
          "bash" = "deny";
          "srt *'bash *" = "deny";
          "srt *'bash'*" = "deny";
          "sh *" = "deny";
          "sh" = "deny";
          "srt *'sh *" = "deny";
          "srt *'sh'*" = "deny";
          "zsh *" = "deny";
          "zsh" = "deny";
          "srt *'zsh *" = "deny";
          "srt *'zsh'*" = "deny";
          "dash *" = "deny";
          "srt *'dash *" = "deny";
          "python *" = "deny";
          "python3 *" = "deny";
          "srt *'python *" = "deny";
          "srt *'python3 *" = "deny";
          "python -c *" = "deny";
          "python3 -c *" = "deny";
          "srt *'python -c *" = "deny";
          "srt *'python3 -c *" = "deny";
          "perl *" = "deny";
          "srt *'perl *" = "deny";
          "ruby *" = "deny";
          "srt *'ruby *" = "deny";
          "node -e *" = "deny";
          "node --eval *" = "deny";
          "srt *'node -e *" = "deny";
          "srt *'node --eval *" = "deny";
          "eval *" = "deny";
          "srt *'eval *" = "deny";
          "source *" = "deny";
          "srt *'source *" = "deny";
          ". *" = "deny";
          "srt *'. *" = "deny";

          # Credential/environment access.
          "env" = "deny";
          "env *" = "deny";
          "srt *'env'*" = "deny";
          "srt *'env *" = "deny";
          "printenv" = "deny";
          "printenv *" = "deny";
          "srt *'printenv'*" = "deny";
          "srt *'printenv *" = "deny";
          "set" = "deny";
          "set *" = "deny";
          "srt *'set'*" = "deny";
          "srt *'set *" = "deny";
          "export" = "deny";
          "export *" = "deny";
          "srt *'export'*" = "deny";
          "srt *'export *" = "deny";
          "history" = "deny";
          "history *" = "deny";
          "srt *'history'*" = "deny";
          "srt *'history *" = "deny";
          "cat /proc/*/environ" = "deny";
          "cat /proc/*" = "deny";
          "srt *'cat /proc/*" = "deny";

          # Execution vectors.
          "xargs *" = "deny";
          "srt *'xargs *" = "deny";
          "chmod +x *" = "deny";
          "srt *'chmod +x *" = "deny";
          "chmod 7* *" = "deny";
          "srt *'chmod 7* *" = "deny";

          # Stealth file writes.
          "tee *" = "deny";
          "srt *'tee *" = "deny";

          # Network access. No sandbox means no domain filtering.
          "curl *" = "deny";
          "srt *'curl *" = "deny";
          "wget *" = "deny";
          "srt *'wget *" = "deny";
          "nc *" = "deny";
          "srt *'nc *" = "deny";
          "ncat *" = "deny";
          "srt *'ncat *" = "deny";
          "netcat *" = "deny";
          "srt *'netcat *" = "deny";
          "socat *" = "deny";
          "srt *'socat *" = "deny";
          "ssh *" = "deny";
          "srt *'ssh *" = "deny";
          "scp *" = "deny";
          "srt *'scp *" = "deny";
          "rsync *" = "deny";
          "srt *'rsync *" = "deny";
          "ftp *" = "deny";
          "srt *'ftp *" = "deny";
          "sftp *" = "deny";
          "srt *'sftp *" = "deny";
          "telnet *" = "deny";
          "srt *'telnet *" = "deny";

          # Destructive filesystem operations.
          "rm -rf /" = "deny";
          "rm -rf /*" = "deny";
          "rm -rf ~" = "deny";
          "rm -rf ~/*" = "deny";
          "rm -rf $HOME" = "deny";
          "rm -rf $HOME/*" = "deny";
          "rm --recursive --force /" = "deny";
          "rm --recursive --force /*" = "deny";
          "rm --recursive --force ~" = "deny";
          "rm --recursive --force ~/*" = "deny";
          "rm --recursive --force $HOME" = "deny";
          "rm --recursive --force $HOME/*" = "deny";
          "rm --force --recursive /" = "deny";
          "rm --force --recursive /*" = "deny";
          "rm --force --recursive ~" = "deny";
          "rm --force --recursive ~/*" = "deny";
          "rm --force --recursive $HOME" = "deny";
          "rm --force --recursive $HOME/*" = "deny";
          "rm -fr /" = "deny";
          "rm -fr /*" = "deny";
          "srt *'rm -rf /'*" = "deny";
          "srt *'rm -rf /*" = "deny";
          "srt *'rm -rf ~'*" = "deny";
          "srt *'rm -rf ~/*" = "deny";
          "srt *'rm -rf $HOME'*" = "deny";
          "srt *'rm -rf $HOME/*" = "deny";
          "srt *'rm --recursive --force /'*" = "deny";
          "srt *'rm --recursive --force /*" = "deny";
          "srt *'rm --recursive --force ~'*" = "deny";
          "srt *'rm --recursive --force ~/*" = "deny";
          "srt *'rm --recursive --force $HOME'*" = "deny";
          "srt *'rm --recursive --force $HOME/*" = "deny";
          "srt *'rm --force --recursive /'*" = "deny";
          "srt *'rm --force --recursive /*" = "deny";
          "srt *'rm --force --recursive ~'*" = "deny";
          "srt *'rm --force --recursive ~/*" = "deny";
          "srt *'rm --force --recursive $HOME'*" = "deny";
          "srt *'rm --force --recursive $HOME/*" = "deny";
          "srt *'rm -fr /'*" = "deny";
          "srt *'rm -fr /*" = "deny";
          "dd *" = "deny";
          "srt *'dd *" = "deny";
          "shred *" = "deny";
          "srt *'shred *" = "deny";
          "mkfs *" = "deny";
          "srt *'mkfs *" = "deny";
          "wipefs *" = "deny";
          "srt *'wipefs *" = "deny";
          "fdisk *" = "deny";
          "srt *'fdisk *" = "deny";
          "parted *" = "deny";
          "srt *'parted *" = "deny";

          # Privilege escalation.
          "sudo *" = "deny";
          "su *" = "deny";
          "doas *" = "deny";
          "pkexec *" = "deny";
          "srt *'sudo *" = "deny";
          "srt *'su *" = "deny";
          "srt *'doas *" = "deny";
          "srt *'pkexec *" = "deny";

          # Git dangerous operations.
          "git push --force *" = "deny";
          "git push -f *" = "deny";
          "git push --force-with-lease *" = "allow";
          "git push --force-with-lease=*" = "allow";
          "git reset --hard *" = "deny";
          "git clean -fd *" = "deny";
          "git clean -fdx *" = "deny";
          "git remote set-url *" = "deny";
          "git remote add *" = "deny";
          "git remote remove *" = "deny";
          "git config *" = "deny";
          "srt *'git push --force *" = "deny";
          "srt *'git push -f *" = "deny";
          "srt *'git push --force-with-lease *" = "allow";
          "srt *'git push --force-with-lease=*" = "allow";
          "srt *'git reset --hard *" = "deny";
          "srt *'git clean -fd *" = "deny";
          "srt *'git clean -fdx *" = "deny";
          "srt *'git remote set-url *" = "deny";
          "srt *'git remote add *" = "deny";
          "srt *'git remote remove *" = "deny";
          "srt *'git config *" = "deny";

          # Security management.
          "agent-security *" = "deny";
          "srt *'agent-security *" = "deny";

          # Miscellaneous dangerous commands.
          "kill *" = "deny";
          "srt *'kill *" = "deny";
          "killall *" = "deny";
          "srt *'killall *" = "deny";
          "pkill *" = "deny";
          "srt *'pkill *" = "deny";
          "reboot" = "deny";
          "srt *'reboot'*" = "deny";
          "shutdown *" = "deny";
          "srt *'shutdown *" = "deny";
          "systemctl *" = "deny";
          "srt *'systemctl *" = "deny";
          "service *" = "deny";
          "srt *'service *" = "deny";
          "iptables *" = "deny";
          "srt *'iptables *" = "deny";
          "nft *" = "deny";
          "srt *'nft *" = "deny";

          # Shell metacharacter injection. This can bypass command chaining restrictions.
          "*;*" = "deny";
          "*&&*" = "deny";
          "*||*" = "deny";
          "*|*" = "deny";
          "*$(*" = "deny";
          "*`*" = "deny";

          # Absolute paths to interpreters.
          "/bin/bash *" = "deny";
          "/usr/bin/bash *" = "deny";
          "/bin/sh *" = "deny";
          "/usr/bin/sh *" = "deny";
          "/usr/bin/python *" = "deny";
          "/usr/bin/python3 *" = "deny";
          "/usr/local/bin/python *" = "deny";
          "/usr/local/bin/python3 *" = "deny";
          "/usr/bin/perl *" = "deny";
          "/usr/bin/ruby *" = "deny";
          "/usr/bin/node *" = "deny";
          "srt *'/bin/bash *" = "deny";
          "srt *'/usr/bin/bash *" = "deny";
          "srt *'/bin/sh *" = "deny";
          "srt *'/usr/bin/sh *" = "deny";
          "srt *'/usr/bin/python *" = "deny";
          "srt *'/usr/bin/python3 *" = "deny";
          "srt *'/usr/bin/perl *" = "deny";
          "srt *'/usr/bin/ruby *" = "deny";
          "srt *'/usr/bin/node *" = "deny";

          # Indirect execution wrappers.
          "command *" = "deny";
          "srt *'command *" = "deny";
          "exec *" = "deny";
          "srt *'exec *" = "deny";

          # Restrict rm to prevent configuration deletion and recursive wipes.
          "rm -r *" = "deny";
          "rm -rf *" = "deny";
          "rm -fr *" = "deny";
          "rm --recursive *" = "deny";
          "rm --recursive --force *" = "deny";
          "rm --force --recursive *" = "deny";
          "rm *opencode*" = "deny";
          "rm *.opencode*" = "deny";
          "srt *'rm -r *" = "deny";
          "srt *'rm -rf *" = "deny";
          "srt *'rm -fr *" = "deny";
          "srt *'rm --recursive *" = "deny";
          "srt *'rm --recursive --force *" = "deny";
          "srt *'rm --force --recursive *" = "deny";
          "srt *'rm *opencode*" = "deny";
          "srt *'rm *.opencode*" = "deny";

          # make is arbitrary code execution.
          "make *" = "ask";
          "make" = "ask";
          "srt *'make *" = "ask";
          "srt *'make'*" = "ask";

          # Restrict blanket srt -s. This can execute wrapped commands.
          "srt -s *" = "ask";

          # Nix-specific documentation sources allowed via curl.
          "curl *man7.org/linux/man-pages/*" = "allow";
          "srt *'curl *man7.org/linux/man-pages/*" = "allow";
          "curl *nix-community.github.io*" = "allow";
          "srt *'curl *nix-community.github.io*" = "allow";
          "curl *nix.dev*" = "allow";
          "srt *'curl *nix.dev*" = "allow";
          "curl *nixos.wiki*" = "allow";
          "srt *'curl *nixos.wiki*" = "allow";
          "curl *wiki.nixos.org*" = "allow";
          "srt *'curl *wiki.nixos.org*" = "allow";
        };
      }; # https://opencode.ai/docs/config/#permissions
      instructions = [
        "AGENTS.md"
      ]; # https://opencode.ai/docs/config/#instructions
      formatter = import ./formatter.nix; # # https://opencode.ai/docs/config/#formatters
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.settings
    skills = commonLlmSettings.mattPocockSkills // {
      # https://opencode.ai/docs/skills/
      beads = "${pkgs.beads.src}/claude-plugin/skills/beads"; # A skill can also be a subdirectory within a Nix package source store path.
      find-skills = "${commonLlmSettings.vercelSkillsSrc}/skills/find-skills";
      frontend-design = "${commonLlmSettings.anthropicSkillsSrc}/skills/frontend-design";
      apply-owasp-security = commonLlmSettings.skills.apply-owasp-security;
      fix-github-issue = commonLlmSettings.skills.fix-github-issue;
      upsert-git-commit = commonLlmSettings.skills.upsert-git-commit;
      upsert-github-pull-request = commonLlmSettings.skills.upsert-github-pull-request;
      upsert-github-release = commonLlmSettings.skills.upsert-github-release;
      superpowers-brainstorming = "${commonLlmSettings.superpowersSrc}/skills/brainstorming";
      superpowers-dispatching-parallel-agents = "${commonLlmSettings.superpowersSrc}/skills/dispatching-parallel-agents";
      superpowers-executing-plans = "${commonLlmSettings.superpowersSrc}/skills/executing-plans";
      superpowers-finishing-a-development-branch = "${commonLlmSettings.superpowersSrc}/skills/finishing-a-development-branch";
      superpowers-receiving-code-review = "${commonLlmSettings.superpowersSrc}/skills/receiving-code-review";
      superpowers-requesting-code-review = "${commonLlmSettings.superpowersSrc}/skills/requesting-code-review";
      superpowers-subagent-driven-development = "${commonLlmSettings.superpowersSrc}/skills/subagent-driven-development";
      superpowers-systematic-debugging = "${commonLlmSettings.superpowersSrc}/skills/systematic-debugging";
      superpowers-test-driven-development = "${commonLlmSettings.superpowersSrc}/skills/test-driven-development";
      superpowers-using-git-worktrees = "${commonLlmSettings.superpowersSrc}/skills/using-git-worktrees";
      superpowers-using-superpowers = "${commonLlmSettings.superpowersSrc}/skills/using-superpowers";
      superpowers-verification-before-completion = "${commonLlmSettings.superpowersSrc}/skills/verification-before-completion";
      superpowers-writing-plans = "${commonLlmSettings.superpowersSrc}/skills/writing-plans";
      superpowers-writing-skills = "${commonLlmSettings.superpowersSrc}/skills/writing-skills";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.skills
    themes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.themes
    tools = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.tools # Enables or disables specific tools globally.
  };
}
