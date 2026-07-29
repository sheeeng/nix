# Commands

## Getting Started

```shell
export NIX_CONFIG="experimental-features = nix-command flakes"; # nix --extra-experimental-features 'nix-command flakes'

nix flake update; \
darwin-rebuild build --flake ~/github/sheeeng/nix 2>&1 \
| nix -run nixpkgs#nix-output-monitor

sudo darwin-rebuild switch --flake ~/github/sheeeng/nix 2>&1 \
| nix run nixpkgs#nix-output-monitor
```

```shell
sudo --validate; \
nix flake update; \
sudo --validate; \
sudo nix run github:lnl7/nix-darwin -- switch --flake ~/github/sheeeng/nix  --print-build-logs --show-trace --verbose --cores 2 --max-jobs 2 2>&1 \
| nix run nixpkgs#nix-output-monitor
```

```shell
sudo --validate && nix flake update && sudo --validate && sudo nix run github:lnl7/nix-darwin -- switch --flake ~/github/sheeeng/nix  --print-build-logs --show-trace --verbose --cores 2 --max-jobs 2 2>&1 | nix run nixpkgs#nix-output-monitor
```

```shell
sudo darwin-rebuild switch --print-build-logs --flake ~/github/sheeeng/nix 2>&1 \
| nix run nixpkgs#nix-output-monitor
```

```shell
sudo --validate; \
nix flake update; \
sudo nixos-rebuild switch --print-build-logs --show-trace --verbose --cores 2 --max-jobs 2 --flake ~/github/sheeeng/nix 2>&1 \
| nix run nixpkgs#nix-output-monitor
```

```shell
sudo --validate && nix flake update && sudo --validate && sudo nixos-rebuild switch --print-build-logs --show-trace --verbose --cores 2 --max-jobs 2 --flake ~/github/sheeeng/nix 2>&1 | nix run nixpkgs#nix-output-monitor
```

## Install `lix`

```shell
curl --silent --show-error --fail --location https://install.lix.systems/lix | sh -s -- install
```

## Miscellaneous

- Restart Nix daemon.

```shell
sudo launchctl kickstart -k -p system/systems.determinate.nix-daemon
```

- Verify access token.

```shell
nix config show | nix run nixpkgs#ripgrep -- '^access-tokens'
```

- Update and fetch dependencies.

```shell
# Update only Matt Pocock's skills.
nix flake update matt-pocock-skills

# Local binary mode: simplest per-file update using installed tooling.
fd --extension nix --exclude flake.nix --exec update-nix-fetchgit

# Local debug mode: trace each shell step while processing files.
fd --extension nix --exclude flake.nix \
  -x sh -xc 'echo "$1"; update-nix-fetchgit "$1"' _ {}

# Local normal mode: print the current file, then run one update per file.
fd --extension nix --exclude flake.nix \
  -x sh -c 'echo "$1"; update-nix-fetchgit "$1"' _ {}

# Nix-run batch mode: most reproducible and usually fastest for many files.
nix run nixpkgs#fd -- \
  --extension nix \
  --exclude flake.nix \
  --exec-batch \
  nix run nixpkgs#update-nix-fetchgit -- --verbose

# Nix-run per-file mode: sequential per-file output using pinned nixpkgs tools.
nix run nixpkgs#fd -- --extension nix --exclude flake.nix --threads 1 --exec \
  sh -c 'echo "$1"; nix run nixpkgs#update-nix-fetchgit -- "$1"' _ {}
```

- Format files.

```shell
nix fmt

nix-shell --packages nixfmt-tree --run "treefmt ."
```

```shell
find . -name "*.nix" -print0 | xargs -0 nix run github:swarsel/pedantix -- --check
```

## GitHub Token Configuration

The Nix configuration uses sops-nix to securely manage GitHub access tokens for private repository access. The token is stored in encrypted secrets and injected into `nix.conf` at build time.

### How It Works

1. **Secret Storage**: GitHub tokens are stored in `nix-secrets/secrets/hosts/<hostname>.yaml` under the key `tokens/github/repo_scope`
2. **Template Generation**: sops-nix creates a template file at runtime with the format:

    ```text
    access-tokens = github.com=<token>
    ```

3. **Nix Configuration**: The template is included in `nix.conf` via `!include` directive (the `!` prefix makes missing files non-fatal during build)

### Implementation Details

- **Darwin hosts**: `hosts/darwin/sops.nix` defines the template and secret
- **Linux hosts**: `hosts/linux/sops.nix` defines the template and secret
- **Host configurations**: Each host includes the template path in `nix.extraOptions`:

    ```nix
    nix.extraOptions = ''
      !include ${config.sops.templates.nix-access-token.path}
    '';
    ```

#### Determinate Nix Specific Configuration

For Darwin hosts using Determinate Nix (where `nix.enable = false`), the `nix.extraOptions` approach doesn't work because nix-darwin doesn't manage `/etc/nix/nix.conf`. Instead, we use a system activation script to write the configuration:

1. **Activation Script Location**: `system.activationScripts.postActivation` in each Darwin host configuration
2. **Target File**: `/etc/nix/nix.custom.conf` (read by Determinate Nix's `/etc/nix/nix.conf`)
3. **Configuration Chain**:

    ```text
    /etc/nix/nix.conf (managed by Determinate Nix)
      └─> !include nix.custom.conf
            └─> /etc/nix/nix.custom.conf (managed by nix-darwin activation script)
                  └─> !include /var/run/secrets/rendered/nix-access-token
                        └─> access-tokens = github.com=<token>
    ```

The activation script:

- Runs after sops-nix creates the token template
- Removes duplicate access-token entries to prevent conflicts
- Writes the `!include` directive to `/etc/nix/nix.custom.conf`
- Handles missing token file gracefully (expected on first activation)

### Verification Commands

After system activation, verify the token configuration:

```shell
# Check that nix.custom.conf contains the include directive
cat /etc/nix/nix.custom.conf

# Verify the token template exists and has content (requires sudo)
sudo cat /var/run/secrets/rendered/nix-access-token

# Confirm Nix sees the access token
nix show-config | grep access-tokens

# Test with a private repository (if available)
nix flake metadata github:owner/private-repo
```

Expected output:

- `/etc/nix/nix.custom.conf` should contain: `!include /var/run/secrets/rendered/nix-access-token`
- `/var/run/secrets/rendered/nix-access-token` should contain: `access-tokens = github.com=ghp_...`
- `nix show-config` should show: `access-tokens = github.com=ghp_...`

### Benefits

- Tokens never appear in the Nix store or version control
- Declarative configuration across all hosts
- Automatic token injection at build time
- Works with both NixOS and nix-darwin (including Determinate Nix)
- Graceful handling of missing secrets during initial setup

### References

- [NixOS/nix#6536 (comment)][nix-issue-6536-comment] - Original implementation method
- [sops-nix Documentation][sops-nix-docs] - Template and secret management
- [Determinate Nix Documentation][determinate-nix-docs] - Determinate Nix custom configuration

## Nix

```shell
# Enter the default minimal shell
nix develop

# Enter the full development shell with all tools
nix develop .#full

# Enter the minimal shell explicitly
nix develop .#minimal

# Check what shells are available
nix flake show

# Fast nix-darwin switch without Node.js tests (recommended)
just switch-fast-nom

# Alternative fast switch command
just switch-fast

# Check for Node.js dependencies in home-manager packages
grep --recursive --include="*.nix" "nodejs" home-manager/packages/

# Verify Node.js overlay is applied
nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.nodejs.pname'

nix flake show --json | jq '.devShells."aarch64-darwin" // .devShells."x86_64-linux" // {} | keys[]'

# Verify renovate.json configuration (using renovate-config-validator)
nix shell github:nixos/nixpkgs/nixpkgs-unstable#nodejs-slim --command npx --yes --package renovate -- renovate-config-validator --strict

# Alternative: Verify renovate.json configuration (dry-run validates config)
nix shell github:nixos/nixpkgs/nixpkgs-unstable#nodejs-slim --command npx --yes renovate --dry-run --log-level=debug

# Check Renovate version
nix shell github:nixos/nixpkgs/nixpkgs-unstable#nodejs-slim --command npx --yes renovate --version

nix run '.#formatter' -- .github/copilot-journals.md

nix repl --file '<nixpkgs>'

nix eval '.#darwinConfigurations.<hostname>.config.home-manager.users'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.nix.version'

nix eval --json 'nixpkgs#nix.version'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.config.nix.enable'

sudo darwin-rebuild switch --flake .
```

```shell
nix --extra-experimental-features "flakes nix-command" eval --impure --expr 'let receiptPath = "/nix/receipt.json"; receiptExists = builtins.pathExists receiptPath; receiptContent = if receiptExists then builtins.readFile receiptPath else "{}"; receiptJSON = builtins.fromJSON receiptContent; plannerSettingsDeterminateNixEnabled = receiptExists && receiptJSON ? planner && receiptJSON.planner ? settings && receiptJSON.planner.settings ? determinate_nix && receiptJSON.planner.settings.determinate_nix; in plannerSettingsDeterminateNixEnabled'
```

```console
$ nix-shell --packages nixfmt-rfc-style
error:
       … while calling the 'import' builtin
         at «string»:1:18:
            1| {...}@args: with import <nixpkgs> args; (pkgs.runCommandCC or pkgs.runCommand) "shell" { buildInputs = [ (nixfmt-rfc-style) ]; } ""
             |                  ^

       … while realising the context of a path

       … while calling the 'findFile' builtin
         at «string»:1:25:
            1| {...}@args: with import <nixpkgs> args; (pkgs.runCommandCC or pkgs.runCommand) "shell" { buildInputs = [ (nixfmt-rfc-style) ]; } ""
             |                         ^

       error: file 'nixpkgs' was not found in the Nix search path (add it using $NIX_PATH or -I)
$
```

```shell
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update
nix-shell --packages nixfmt-rfc-style

nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz --packages nixfmt-rfc-style

nix-shell -p nixfmt-rfc-style -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz

nix-channel --list

nix-shell --packages nixfmt-rfc-style
```

```nix
# shell.nix -> nix-shell
# nix shell nixpkgs#nixfmt-rfc-style
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ pkgs.nixfmt-rfc-style ];
}
```

## Historical Commands

```shell
nix-shell --packages nix-prefetch-git --run 'nix-prefetch-git --url <https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized> --rev dc5a3e6fcc2e16ad476b7be3c3c17c2273b260ea'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.sf-mono-nerd-font-ligatured.pname' 2>&1

nix eval --impure --json --expr 'let inputs = { nixpkgs = import <nixpkgs> {}; }; overlays = import ./overlays inputs; in builtins.hasAttr "sf-mono-nerd-font-ligatured" overlays'

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.sf-mono'

nix why-depends /run/current-system nodejs 2>/dev/null | head -20

nix eval --json '.#darwinConfigurations.TP95V9LWWL.config.nixpkgs.overlays' | jq length

nix search nixpkgs hadolint --json | jq '.[].pname' 2>/dev/null || echo "Failed to search hadolint"

nix run nixpkgs#prettier -- --write renovate.json --no-config

nix why-depends /run/current-system nodejs 2>/dev/null | head -20

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.nodejs.version' 2>/dev/null || echo "nodejs not found in pkgs"

nix eval --json '.#darwinConfigurations.TP95V9LWWL.pkgs.nodejs_20.version' 2>/dev/null || echo "nodejs_20 not found"

nix build '.#checks.aarch64-darwin.formatting' --no-link --print-build-logs

nix flake check --no-build 2>&1

nix run '.#formatter' -- --check .

nix develop --print-build-logs --show-trace --verbose

nix run nixpkgs#nix-output-monitor -- develop --print-build-logs --show-trace --verbose

nix build --log-format internal-json --verbose ... |& nix run nixpkgs#nix-output-monitor -- --json
nix run nixpkgs#nix-output-monitor -- develop --print-build-logs --show-trace --verbose --command bash -lc 'opencode --version'
```

```shell
nom build .#darwinConfigurations.TP95V9LWWL.config.system.build.toplevel --out-link old

darwin-rebuild build --print-build-logs --flake ~/github/sheeeng/nix 2>&1 | nix run nixpkgs#nix-output-monitor

nom build .#darwinConfigurations.TP95V9LWWL.config.system.build.toplevel --out-link old

nix flake show
nix repl nixpkgs
nix-repl> :lf .

nix-repl> lib. TAB TAB TAB
nix-repl> lib.attrNames darwinConfigurations.TP95V9LWWL.config.system.build.toplevel
nix-repl> :b darwinConfigurations.TP95V9LWWL.config.system.build.toplevel

nix run nixpkgs#tokei

nix flake update;
nix --extra-experimental-features "flakes nix-command" flake check

nix --extra-experimental-features 'flakes nix-command' flake update; darwin-rebuild build --print-build-logs -L --flake ~/github/sheeeng/nix 2>&1 | nix --extra-experimental-features 'flakes nix-command' run nixpkgs#nix-output-monitor

darwin-rebuild build --print-build-logs --flake ~/github/sheeeng/nix 2>&1 | nix --extra-experimental-features 'flakes nix-command' run nixpkgs#nix-output-monitor

darwin-rebuild build --print-build-logs --flake ~/github/sheeeng/nix 2>&1 | nix run nixpkgs#nix-output-monitor

sudo darwin-rebuild switch --print-build-logs --flake ~/github/sheeeng/nix 2>&1 | nix --extra-experimental-features 'flakes nix-command' run nixpkgs#nix-output-monitor

sudo darwin-rebuild switch --print-build-logs --flake ~/github/sheeeng/nix 2>&1 | nix run nixpkgs#nix-output-monitor

nix run nixpkgs#sbomnix -- .#darwinConfigurations.TP95V9LWWL.config.system.build.toplevel
```

```shell
nix repl --include nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
> pkgs = import <nixpkgs> {}
> pkgs.stdenv.hostPlatform
```

```console
$ nix repl
nix-repl> :lf .
```

```shell
nix repl ".#darwinConfigurations.$(hostname)"
nix repl --expr "builtins.getFlake \"$PWD\""
```

```shell
git config --unset-all remote.origin.pushurl; \
git remote set-url origin git@github.com:sheeeng/nix.git \
&& git remote set-url --add --push origin git@git.sr.ht:~sheeeng/nix \
&& git remote set-url --add --push origin git@gitea.com:sheeeng/nix.git \
&& git remote set-url --add --push origin git@github.com:sheeeng/nix.git \
&& git remote set-url --add --push origin git@gitlab.com:sheeeng/nix.git \
&& git remote set-url --add --push origin ssh://git@codeberg.org/sheeeng/nix.git

# git remote set-url --delete --push origin 'ssh://git@codeberg.org/sheeeng/nix.git'
# git config --unset-all remote.origin.pushurl
```

```shell
nix-shell --include nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz --packages nix-info --run "nix-info --markdown"
nix run nixpkgs#nix-info -- "--markdown"
nix shell nixpkgs#nix-info --command nix-info --markdown
```

```console
TP95V9LWWL% nix-shell --include nixpkgs=channel:nixpkgs-unstable --packages nix --run "nix --version"

TP95V9LWWL% nix-shell --include nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz --packages nix-info --run "nix-info --markdown"

TP95V9LWWL% # https://github.com/NixOS/nix/issues/7894#issuecomment-2367730519
sudo unlink /etc/bashrc
sudo unlink /etc/zshrc

TP95V9LWWL% sudo darwin-rebuild switch --print-build-logs --flake ~/github/sheeeng/nix 2>&1 | nix --extra-experimental-features 'flakes nix-command' run nixpkgs#nix-output-monitor
sudo: darwin-rebuild: command not found
sudo nix run github:LnL7/nix-darwin -- switch --flake ~/github/sheeeng/nix --print-build-logs 2>&1 | nix run nixpkgs#nix-output-monitor


TP95V9LWWL% sudo nix run github:lnl7/nix-darwin -- switch --flake ~/github/sheeeng/nix --print-build-logs 2>&1 | nix run nixpkgs#nix-output-monitor
warning: $HOME ('/Users/leonardlee') is not owned by you, falling back to the one defined in the 'passwd' file ('/var/root')
building the system configuration...
The authenticity of host 'github.com (140.82.121.3)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names.
⏱ 16s
Host key verification failed.
TP95V9LWWL% sudo ssh -T git@github.com
```

```shell
# On fast machine
nix build .#nixosConfigurations.slow-computer.config.system.build.toplevel
nix copy --to ssh://root@<slow computer IP> ./result
readlink ./result

# On slow machine
/nix/store/<path that the readlink shows>/bin/switch-to-configuration switch
```

## GitHub

- [Purge all notifications](https://github.com/orgs/community/discussions/174310#discussioncomment-14514685).

```shell
gh api notifications | jq -r '.[] | select(.unread == true) | .id' | nix-shell -p findutils --run 'xargs --replace={} gh api -X DELETE "notifications/threads/{}"'
```

---

[determinate-nix-docs]: https://docs.determinate.systems/determinate-nix/
[nix-issue-6536-comment]: https://github.com/NixOS/nix/issues/6536#issuecomment-1254858889
[sops-nix-docs]: https://github.com/Mic92/sops-nix
