# GPG and SSH Agent Setup for NixOS

This document describes the GPG and SSH key agent configuration for NixOS hosts in this repository.

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                 gpg-agent                       │
│        (home-manager services.gpg-agent)        │
├─────────────────────────────────────────────────┤
│  - GPG key operations (signing, encryption)     │
│  - YubiKey/smart card support (via pcscd)       │
│  - Pinentry (gnome3 or curses based on display) │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│                 ssh-agent                       │
│        (home-manager services.ssh-agent)        │
├─────────────────────────────────────────────────┤
│  - SSH key caching for file-based keys          │
│  - Passphrase caching (AddKeysToAgent)          │
│  - Automatic key loading on first use           │
└─────────────────────────────────────────────────┘
```

The configuration uses **separate agents** for GPG and SSH:

- **gpg-agent**: Handles GPG signing, encryption, and YubiKey/smart card operations
- **ssh-agent**: Handles file-based SSH key passphrase caching

This approach is simpler for file-based SSH keys (`~/.ssh/id_ed25519`) and avoids the complexity of GPG-based SSH authentication.

## Configuration Files

| File | Purpose |
|------|---------|
| `home-manager/programs/gnupg/default.nix` | GPG and gpg-agent configuration |
| `home-manager/programs/ssh.nix` | SSH client configuration |
| `home-manager/packages/git/default.nix` | Enables ssh-agent on Linux |
| `hosts/nixos/default.nix` | NixOS system-level services (pcscd) |

## Key Configuration Details

### GPG Agent (Home-Manager)

The gpg-agent is configured in `home-manager/programs/gnupg/default.nix`:

```nix
services.gpg-agent = {
  enable = true;
  enableSshSupport = false;       # Disabled - ssh-agent handles SSH keys
  enableScDaemon = true;          # Smart card support for GPG
  defaultCacheTtl = 28800;        # 8 hours cache
  maxCacheTtl = 86400;            # 24 hours max cache
  # Shell integrations
  enableBashIntegration = true;
  enableZshIntegration = true;
  enableFishIntegration = true;
  enableNushellIntegration = true;
};
```

### SSH Agent (Home-Manager)

The ssh-agent is enabled in `home-manager/packages/git/default.nix`:

```nix
# Enable ssh-agent on Linux for file-based SSH keys.
services.ssh-agent.enable = if pkgs.stdenv.isDarwin then false else true;
```

### SSH Client Configuration

Configured in `home-manager/programs/ssh.nix`:

```nix
programs.ssh.matchBlocks."*" = {
  addKeysToAgent = "yes";  # Automatically add keys on first use
};

# GPG_TTY is set for pinentry in terminals
home.sessionVariablesExtra = lib.mkIf pkgs.stdenv.isLinux ''
  export GPG_TTY="$(tty)"
'';
```

The `addKeysToAgent = "yes"` setting means:
- First SSH connection prompts for passphrase
- Key is automatically added to ssh-agent
- Subsequent connections use the cached key (no passphrase needed)

### System Services (NixOS)

Configured in `hosts/nixos/default.nix`:

```nix
# Smart card daemon for YubiKey support with GPG
services.pcscd.enable = true;

# Disable yubikey-agent (not needed, gpg-agent handles YubiKey for GPG)
services.yubikey-agent.enable = false;

# Disable system-level gpg-agent (home-manager manages it)
programs.gnupg.agent.enable = false;

# Disable system SSH agent - home-manager's ssh-agent.service is used
programs.ssh.startAgent = false;

# Disable GNOME's gcr-ssh-agent to prevent SSH_AUTH_SOCK conflicts
systemd.user.sockets.gcr-ssh-agent.enable = false;
```

### Disabled Services

To avoid conflicts, the following are explicitly disabled:

| Service | Reason |
|---------|--------|
| `programs.ssh.startAgent` | home-manager ssh-agent is used instead |
| `services.yubikey-agent` | gpg-agent handles YubiKey for GPG operations |
| `programs.gnupg.agent` (system) | home-manager gpg-agent is used instead |
| `gcr-ssh-agent.socket` | GNOME's SSH agent conflicts with home-manager ssh-agent |

## GNOME Desktop Considerations

When using GNOME desktop, the `gcr-ssh-agent` socket is disabled to prevent it from overriding `SSH_AUTH_SOCK`. The home-manager `ssh-agent.service` provides the SSH agent instead.

## How SSH Key Caching Works

1. **First use**: SSH prompts for your key passphrase
2. **Automatic caching**: With `addKeysToAgent = "yes"`, the key is added to ssh-agent
3. **Subsequent uses**: No passphrase needed until you log out or reboot

The ssh-agent caches keys for the duration of your session. After logout or reboot, you'll need to enter the passphrase again on first use.

## Pinentry Configuration

The pinentry program for GPG is selected automatically based on the display environment:

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

## Troubleshooting

### SSH Still Asking for Passphrase Every Time

1. **Verify ssh-agent is running**:
   ```bash
   systemctl --user status ssh-agent.service
   ```

2. **Check SSH_AUTH_SOCK**:
   ```bash
   echo $SSH_AUTH_SOCK
   # Should show something like /run/user/1000/ssh-agent
   ```

3. **List keys in agent**:
   ```bash
   ssh-add -l
   ```

4. **Manually add key** (temporary fix):
   ```bash
   ssh-add ~/.ssh/id_ed25519
   ```

### GPG Signing Not Working

1. **Verify GPG_TTY is set**:
   ```bash
   echo $GPG_TTY
   ```

2. **Test GPG signing**:
   ```bash
   echo "test" | gpg --clearsign
   ```

3. **Restart gpg-agent**:
   ```bash
   gpgconf --kill gpg-agent
   gpg-connect-agent /bye
   ```

### After Rebuild, Agents Not Working

Log out and log back in (or reboot) to ensure systemd user services are restarted with the correct environment.

## Applying Changes

After modifying the configuration:

```bash
# Rebuild NixOS
sudo nixos-rebuild switch --flake .

# Log out and log back in for systemd user services to restart
```

## Commands Reference

```bash
# Check ssh-agent status
systemctl --user status ssh-agent.service

# List SSH keys in agent
ssh-add -l

# Add SSH key manually
ssh-add ~/.ssh/id_ed25519

# Check gpg-agent status
gpg-connect-agent 'getinfo version' /bye

# Reload gpg-agent
gpg-connect-agent reloadagent /bye

# Update TTY for pinentry
gpg-connect-agent updatestartuptty /bye

# Test GPG signing
echo "test" | gpg --clearsign

# Test SSH connection
ssh -T git@github.com
```

## Related Documentation

- [GPG Signing Troubleshooting](./gpg-signing-troubleshooting.md)
- [Home-Manager GPG Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.enable)
- [Home-Manager gpg-agent Options](https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enable)
- [Home-Manager ssh-agent Options](https://nix-community.github.io/home-manager/options.xhtml#opt-services.ssh-agent.enable)
