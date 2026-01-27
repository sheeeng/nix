# NixOS Laptop Setup

## Configuration Overview

Your new NixOS laptop configuration in this directory reuses:

✅ **From Darwin Config:**

- SOPS secrets management
- All Nerd Fonts and Noto fonts
- Environment variables (EDITOR, SSH_AUTH_SOCK, etc.)
- System packages (nh, nixd, nvd, etc.)
- Nix settings (experimental features, cachix, etc.)
- Home Manager integration
- Activation scripts with nvd diffs

✅ **From Home Manager:**

- All programs (neovim, kitty, zsh, etc.)
- All packages
- All dotfiles and configurations

## Hardware Details (Already Configured)

Your laptop has:

- **CPU:** AMD (with KVM)
- **Storage:** NVMe with LUKS encryption
- **Boot:** UEFI with systemd-boot
- **Network:** WiFi via iwd

## Quick Customization

### 1. Set Your Hostname

Edit [default.nix](default.nix#L15):

```nix
networking = {
  hostName = "your-laptop-name"; # Change this
};
```

### 2. Set Your Username (if different from "leonard")

Edit [default.nix](default.nix#L23):

```nix
user = {
  name = "yourname"; # Change this
  uid = 1000;
  gid = 1000;
};
```

### 3. Update flake.nix

Rename the configuration in [flake.nix](../../flake.nix#L303):

```nix
nixosConfigurations = {
  your-laptop-name = nixosConfiguration "your-laptop-name" "x86_64-linux";
};
```

Then rename the directory:

```bash
mv hosts/nixos hosts/your-laptop-name
```

## Prerequisites

Before you can use this configuration, your laptop needs:

1. ✅ **NixOS installed** - Complete a basic NixOS installation first
2. ✅ **Experimental features enabled** - Required for flakes support
3. ✅ **Git installed** - To clone the repository
4. ✅ **Network connectivity** - To download packages

## Initial Setup on Fresh NixOS Installation

If you've just installed NixOS with the default configuration, follow these steps:

### Step 1: Enable Flakes Temporarily

On a fresh NixOS install, flakes aren't enabled by default. Enable them temporarily:

```bash
# Create a temporary nix.conf for this session
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

Or run commands with the flag:

```bash
nix --extra-experimental-features "nix-command flakes" <command>
```

### Step 2: Install Git (if not already installed)

```bash
nix-shell -p git
```

Or add to your current `/etc/nixos/configuration.nix`:

```nix
environment.systemPackages = with pkgs; [ git ];
```

Then rebuild:

```bash
sudo nixos-rebuild switch
```

### Step 3: Backup Your Hardware Configuration

Your existing hardware configuration was generated during installation:

```bash
# Back it up before proceeding
sudo cp /etc/nixos/hardware-configuration.nix ~/hardware-configuration.nix.backup
```

## Deployment on Your Laptop

### First Time Setup

1. **Clone your repository:**

   ```bash
   git clone <your-repo-url> ~/nix-config
   cd ~/nix-config
   ```

2. **Copy your hardware configuration:**

   ```bash
   # Copy the hardware config from your current NixOS installation
   sudo cp /etc/nixos/hardware-configuration.nix ~/nix-config/hosts/nixos/hardware-configuration.nix
   ```

   Or if you've already generated it, verify it's in place:

   ```bash
   ls -la ~/nix-config/hosts/nixos/hardware-configuration.nix
   ```

3. **Handle SOPS secrets (initial workaround):**

   On first run, SOPS secrets won't be available yet. You have two options:

   **Option A: Temporarily disable SOPS** (easier for first build)

   Comment out the SOPS import in `hosts/nixos/default.nix`:

   ```nix
   imports = [
     ./hardware-configuration.nix
     # ../darwin/sops.nix  # Darwin-only, not needed for NixOS
     inputs.home-manager.nixosModules.home-manager
     # ...
   ];
   ```

   Also comment out the SOPS-dependent line:

   ```nix
   extraOptions = ''
     # !include ${config.sops.templates.nix-access-token.path}  # Comment out
     experimental-features = nix-command flakes
     keep-derivations = true
     keep-outputs = true
   '';
   ```

   **Option B: Create a dummy secrets file** (if you want to keep SOPS)

   See "SOPS Secrets Setup" section below.

4. **Test the build:**

   ```bash
   # If you need flakes temporarily enabled:
   nix --extra-experimental-features "nix-command flakes" build .#nixosConfigurations.nixos.config.system.build.toplevel
   ```

5. **Apply the configuration:**

   ```bash
   # First time with flakes enabled temporarily
   sudo nixos-rebuild switch --flake .#nixos --extra-experimental-features "nix-command flakes"
   ```

   After this first rebuild, flakes will be permanently enabled by your configuration!

6. **Subsequent rebuilds** (after first successful switch):

   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

   Now flakes are enabled in your system configuration, so the flag is no longer needed.

### Subsequent Updates

```bash
cd ~/nix-config
git pull
sudo nixos-rebuild switch --flake .#nixos
```

## SOPS Secrets Setup

Your configuration uses SOPS for secrets management. To enable it:

1. **On your laptop, generate SSH host keys (if not already done):**

   ```bash
   sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
   ```

2. **Get the host's public key:**

   ```bash
   ssh-keyscan -t ed25519 localhost 2>/dev/null | awk '{print $3}'
   # Or read directly:
   sudo cat /etc/ssh/ssh_host_ed25519_key.pub
   ```

3. **Add the public key to your nix-secrets repository:**

   In your `nix-secrets` repo, create `secrets/hosts/nixos.yaml` (or your chosen hostname) and configure `.sops.yaml` to include the new host's public key.

4. **Create the host-specific secrets file:**

   ```bash
   cd /path/to/nix-secrets
   # Edit .sops.yaml to add your new host's key
   sops secrets/hosts/nixos.yaml
   ```

   Add your secrets (GitHub token, age keys, etc.)

5. **Rebuild to activate secrets:**

   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

## Hardware-Specific Optimizations (Optional)

If you want to add hardware-specific optimizations from nixos-hardware:

Uncomment in [default.nix](default.nix#L41):

```nix
imports = [
  # Choose the appropriate module for your laptop:
  inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3
  # inputs.nixos-hardware.nixosModules.dell-xps-13-9310
  # inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  # See: https://github.com/nixos/nixos-hardware

  ./hardware-configuration.nix
  # ../darwin/sops.nix  # Darwin-only, not needed for NixOS
  inputs.home-manager.nixosModules.home-manager
  inputs.agenix.nixosModules.age
  inputs.nixvim.nixosModules.nixvim
];
```

## What Gets Shared Automatically

Because you import `home-manager/home.nix`, you automatically get:

- ✨ Helix, Neovim, and all editor configs
- 🐚 Zsh, Fish, Bash configurations
- 🖥️ Kitty, Alacritty, WezTerm terminal configs
- 📦 All your CLI tools (eza, bat, fzf, ripgrep, etc.)
- 🔑 SSH and GPG configurations
- 🎨 Catppuccin theming
- 📝 Git configurations

## Differences from Darwin

The NixOS configuration intentionally **excludes**:

- macOS-specific settings (Dock, Finder, etc.)
- Touch ID authentication
- mac-app-util
- Darwin-specific activation scripts

Everything else is shared!

## Testing Before Deployment

From your Mac, test the configuration builds:

```bash
nix build .#nixosConfigurations.nixos.config.system.build.toplevel
```

Check what's included:

```bash
nix eval .#nixosConfigurations.nixos.config.environment.systemPackages --apply 'map (p: p.name)' --json | jq
```

## Troubleshooting

### "experimental features not enabled" error

If you get an error about experimental features:

```bash
# Add the flag to your command:
sudo nixos-rebuild switch --flake .#nixos --extra-experimental-features "nix-command flakes"
```

After the first successful rebuild, this is no longer needed.

### "flake.lock not found" or "unable to fetch git repository"

If your nix-secrets repository is private and using SSH:

```bash
# Make sure your SSH keys are set up
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Test SSH access
ssh -T git@github.com
```

If needed, temporarily change the nix-secrets URL in `flake.nix` to use a local path or HTTPS.

### "secrets file not found" error

For the first build, either:

1. **Temporarily disable SOPS** (recommended for first build):
   - Comment out `../darwin/sops.nix` import (Darwin-only, not applicable to NixOS)
   - Comment out the `!include` line in `nix.extraOptions`
   - Rebuild successfully
   - Then uncomment and set up secrets properly

2. **Or create the secrets file** before rebuilding:
   - Make sure you've created `secrets/hosts/nixos.yaml` (or your hostname) in your nix-secrets repository
   - Ensure it's encrypted with your laptop's SSH host key

### WiFi not working

Check your interface name and adjust:

```bash
ip link show
```

Then update in `default.nix`:

```nix
networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;
```

### Different architecture

If your laptop is ARM instead of x86_64, change in both places:

- `default.nix`: `systemPlatform = "aarch64-linux";`
- `flake.nix`: `nixosConfiguration "nixos" "aarch64-linux"`

## Comparison with Other Hosts

| Feature            | Darwin (TP95V9LWWL) | NixOS (this laptop) | Shared? |
| ------------------ | ------------------- | ------------------- | ------- |
| Home Manager       | ✅                  | ✅                  | ✅      |
| SOPS Secrets       | ✅                  | ✅                  | ✅      |
| Fonts              | ✅                  | ✅                  | ✅      |
| System Packages    | ✅                  | ✅                  | ✅      |
| Cachix             | ✅                  | ✅                  | ✅      |
| Activation Scripts | ✅                  | ✅                  | ✅      |
| macOS Settings     | ✅                  | ❌                  | ❌      |
| Touch ID           | ✅                  | ❌                  | ❌      |
| Linux Hardware     | ❌                  | ✅                  | ❌      |
| systemd Services   | ❌                  | ✅                  | ❌      |

## Complete First-Time Checklist

- [ ] NixOS is installed on the laptop
- [ ] You have network connectivity (WiFi or Ethernet)
- [ ] Git is available (`nix-shell -p git` if needed)
- [ ] Flakes enabled temporarily (via flag or nix.conf)
- [ ] Repository cloned to `~/nix-config`
- [ ] Hardware configuration copied to `hosts/nixos/hardware-configuration.nix`
- [ ] Hostname customized in `default.nix`
- [ ] Username customized (if not "leonard")
- [ ] SOPS temporarily disabled for first build (recommended)
- [ ] First rebuild successful with `--extra-experimental-features` flag
- [ ] Second rebuild works without the flag (flakes now enabled)
- [ ] Set up SOPS secrets properly
- [ ] Final rebuild with secrets enabled
- [ ] Enjoy your consistent environment! 🎉

## Common First-Build Issues

**Issue:** "error: cannot find flake.lock"
**Solution:** Make sure you're in the correct directory (`cd ~/nix-config`)

**Issue:** "error: getting status of '/nix/store/...': No such file or directory"
**Solution:** Internet connectivity issue - check your network

**Issue:** "building the system configuration... error: attribute 'sops' missing"
**Solution:** Comment out SOPS temporarily for first build

**Issue:** "error: getting status of '.../hardware-configuration.nix': No such file or directory"
**Solution:** Copy your hardware configuration: `sudo cp /etc/nixos/hardware-configuration.nix ~/nix-config/hosts/nixos/`

## Miscellenous

```shell
# https://github.com/NixOS/nix/issues/8271#issuecomment-2870219149
nixos-rebuild switch --option substituters "https://cache.nixos.org/" --option trusted-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
```
