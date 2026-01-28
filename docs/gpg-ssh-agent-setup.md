# GPG and SSH Agent Setup for NixOS

This document describes the GPG and SSH key agent configuration for NixOS hosts in this repository.

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                 gpg-agent                       │
│        (home-manager services.gpg-agent)        │
├─────────────────────────────────────────────────┤
│  - GPG key operations (signing, encryption)     │
│  - SSH authentication (enableSshSupport)        │
│  - YubiKey/smart card support (via pcscd)       │
│  - Pinentry (gnome3 or curses based on display) │
└─────────────────────────────────────────────────┘
                      │
                      ▼
    $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
                      │
                      ▼
               SSH_AUTH_SOCK
```

The configuration uses **gpg-agent as a unified agent** for both GPG and SSH operations. This approach:

- Eliminates conflicts between multiple agents
- Enables using GPG authentication subkeys for SSH
- Supports YubiKey/smart card–based keys via the smart card daemon
- Provides a consistent experience across terminal and graphical sessions

## Configuration Files

| File | Purpose |
|------|---------|
| `home-manager/programs/gnupg/default.nix` | GPG and gpg-agent configuration |
| `home-manager/programs/ssh.nix` | SSH client and environment variables |
| `home-manager/packages/git/default.nix` | Disables ssh-agent (gpg-agent handles SSH) |
| `hosts/nixos/default.nix` | NixOS system-level services (pcscd) |

## Key Configuration Details

### GPG Agent (Home-Manager)

The gpg-agent is configured in `home-manager/programs/gnupg/default.nix`:

```nix
services.gpg-agent = {
  enable = true;
  enableSshSupport = true;        # Handle SSH keys
  enableScDaemon = true;          # Smart card support
  defaultCacheTtl = 3600;         # 1 hour cache
  maxCacheTtl = 7200;             # 2 hour max cache
  # Shell integrations
  enableBashIntegration = true;
  enableZshIntegration = true;
  enableFishIntegration = true;
  enableNushellIntegration = true;
};
```

### SSH Environment Variables

Configured in `home-manager/programs/ssh.nix`:

```nix
# Point SSH to gpg-agent's socket
home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
  SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh";
};

# Set GPG_TTY for pinentry in terminals
home.sessionVariablesExtra = lib.mkIf pkgs.stdenv.isLinux ''
  export GPG_TTY="$(tty)"
'';
```

### System Services (NixOS)

Configured in `hosts/nixos/default.nix`:

```nix
# Smart card daemon for YubiKey support
services.pcscd.enable = true;

# Disable yubikey-agent (conflicts with gpg-agent SSH support)
services.yubikey-agent.enable = false;

# Disable system-level gpg-agent (home-manager manages it)
programs.gnupg.agent.enable = false;
```

### Disabled Services

To avoid conflicts, the following are explicitly disabled:

| Service | Reason |
|---------|--------|
| `services.ssh-agent` | gpg-agent handles SSH |
| `services.yubikey-agent` | gpg-agent handles YubiKey via scdaemon |
| `programs.gnupg.agent` (system) | home-manager gpg-agent is used instead |

## Pinentry Configuration

The pinentry program is selected automatically based on the display environment:

```nix
pinentry.package = pkgs.writeShellScriptBin "pinentry" ''
  if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
    exec ${pkgs.pinentry-gnome3}/bin/pinentry "$@"
  else
    exec ${pkgs.pinentry-curses}/bin/pinentry "$@"
  fi
'';
```

- **Graphical session**: Uses `pinentry-gnome3` for a GUI dialog
- **Terminal session**: Uses `pinentry-curses` for a text-based dialog

## SSH Key Setup with GPG

To use a GPG authentication subkey for SSH:

### 1. Identify Your Authentication Key

```bash
gpg --list-keys --keyid-format long
```

Look for a key with `[A]` (authentication) capability.

### 2. Get the Keygrip

```bash
gpg --list-keys --with-keygrip
```

### 3. Add to sshcontrol (Optional)

If you want to explicitly control which keys are available for SSH:

```bash
echo "KEYGRIP_HERE" >> ~/.gnupg/sshcontrol
```

### 4. Verify SSH Key Is Available

```bash
ssh-add -L
```

This should display your GPG authentication key in SSH public key format.

## YubiKey Setup

For YubiKey users with GPG keys stored on the device:

### 1. Verify YubiKey Is Detected

```bash
gpg --card-status
```

### 2. Check pcscd Service

```bash
systemctl status pcscd
```

### 3. Fetch Public Key (If Needed)

If the public key is not yet imported:

```bash
gpg --card-edit
> fetch
> quit
```

## Troubleshooting

### SSH Agent Not Working

1. **Verify SSH_AUTH_SOCK**:
   ```bash
   echo $SSH_AUTH_SOCK
   # Should output: /run/user/1000/gnupg/S.gpg-agent.ssh
   ```

2. **Check gpg-agent is running**:
   ```bash
   gpg-connect-agent 'getinfo version' /bye
   ```

3. **Restart gpg-agent**:
   ```bash
   gpgconf --kill gpg-agent
   gpg-connect-agent /bye
   ```

### Pinentry Not Appearing

1. **Verify GPG_TTY is set**:
   ```bash
   echo $GPG_TTY
   # Should output your tty, e.g., /dev/pts/0
   ```

2. **Set manually if needed**:
   ```bash
   export GPG_TTY=$(tty)
   ```

3. **Force terminal pinentry**:
   ```bash
   gpg-connect-agent updatestartuptty /bye
   ```

### YubiKey Not Detected

1. **Check pcscd service**:
   ```bash
   systemctl status pcscd
   sudo systemctl restart pcscd
   ```

2. **Restart scdaemon**:
   ```bash
   gpgconf --kill scdaemon
   gpg --card-status
   ```

3. **Check USB permissions**:
   Ensure your user is in the appropriate groups or that udev rules are configured.

### Multiple Agents Conflict

If you see errors about agents conflicting:

```bash
# Kill all GPG daemons
gpgconf --kill all

# Verify no stale sockets
ls -la $XDG_RUNTIME_DIR/gnupg/

# Restart
gpg-connect-agent /bye
```

## Applying Changes

After modifying the configuration:

```bash
# Rebuild NixOS
sudo nixos-rebuild switch --flake .

# Reload shell or log out/in for environment variables
exec $SHELL

# Or source profile manually
source ~/.profile
```

## Commands Reference

```bash
# Check gpg-agent status
gpg-connect-agent 'getinfo version' /bye

# List SSH keys from gpg-agent
ssh-add -L

# Reload gpg-agent
gpg-connect-agent reloadagent /bye

# Kill and restart gpg-agent
gpgconf --kill gpg-agent
gpg-connect-agent /bye

# Update TTY for pinentry
gpg-connect-agent updatestartuptty /bye

# Test GPG signing
echo "test" | gpg --clearsign

# Test SSH connection
ssh -T git@github.com

# Check YubiKey status
gpg --card-status
```

## Related Documentation

- [GPG Signing Troubleshooting](./gpg-signing-troubleshooting.md)
- [Home-Manager GPG Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.enable)
- [Home-Manager gpg-agent Options](https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enable)
- [NixOS GPG Agent Options](https://search.nixos.org/options?channel=unstable&show=programs.gnupg.agent)
