# Bootstrap the ThinkPad P14s over SSH

Use this procedure after NixOS boots from the laptop's internal drive.
Keep the installed disk layout, bootloader, and working login. The procedure
uses both repositories and keeps the existing boot generation available while
you test the new configuration.

## Connect to the Installed System over Tailscale

From your workstation, connect to the installed laptop over your tailnet:

```bash
ssh llee@p14s
```

From the SSH session, run:

```bash
id
sudo -v
sudo ls -l /etc/ssh/ssh_host_ed25519*
```

If you need to inspect a custom OpenSSH configuration, run
`systemctl cat sshd.service` to find the binary and configuration file
used by the service. A working SSH login and a successful `sudo -v`
are sufficient to continue to host key registration.

## Register the Host in nix

On the workstation, add `hosts/p14s/default.nix` and register the host
under `nixosConfigurations` in `flake.nix`:

```nix
p14s = nixosConfiguration "p14s" "x86_64-linux";
```

Use `hosts/p50/default.nix` as a reference for the shared Linux and Home
Manager imports. Import `../linux` and the laptop's own
`./hardware-configuration.nix`. From the workstation's `nix` checkout,
copy the installed hardware configuration over SSH:

```bash
mkdir -p hosts/p14s
scp llee@p14s:/etc/nixos/hardware-configuration.nix hosts/p14s/
```

Carry over the installed system's bootloader settings, mount points, LUKS
settings if present, and `system.stateVersion`. Set the hostname to `p14s`.

Enable Tailscale in `hosts/p14s/default.nix`:

```nix
services.tailscale.enable = true;
```

For the first activation, retain the working SSH port, firewall access,
login account and UID, and sudo access. Declare your workstation's public
login key through `users.users.<login>.openssh.authorizedKeys.keys` and
verify that the effective `services.openssh.authorizedKeysFiles` includes
the NixOS-managed key file. Review any custom SSH settings copied from
`p50`, which uses port 2222 and a key supplied by Home Manager.

## Register the Laptop's Age Recipient

In the SSH session, use the existing ED25519 host key. With the standard
OpenSSH path, derive the public age recipient as follows:

```bash
sudo ssh-keygen -y -f /etc/ssh/ssh_host_ed25519_key |
  nix --extra-experimental-features 'nix-command flakes' run nixpkgs#ssh-to-age
```

Use the existing ED25519 host key on the laptop. If OpenSSH uses a custom
path, use that path in the command and the SOPS configuration below.
Keep the private host key on the laptop.

The shared Linux SOPS module reads `/etc/ssh/ssh_host_ed25519`. If the
installed system uses the standard path with the `_key` suffix, add `lib`
to the host module arguments and set the following in the P14s module:

```nix
sops.age.sshKeyPaths = lib.mkForce [
  "/etc/ssh/ssh_host_ed25519_key"
];
```

On the workstation, use an administrative identity that can decrypt the
existing files. Apply these corrections in `nix-secrets`:

1. In `.sops.yaml`, add or correct the `&p14s` anchor using the recipient
   printed by the laptop. Add `*p14s` to the common rule and the specific
   rule matching `secrets/hosts/p14s.yaml`. Preserve the administrative
   and recovery recipients and the recipients for other hosts.
2. Open `sops secrets/hosts/p14s.yaml`. Ensure it contains
   `tokens/github/repo_scope` and `keys/age`. Store the user age identity
   expected by Home Manager under `keys/age`. That identity's public
   recipient must also be authorized in `common.yaml`.
3. Apply the rules to the encrypted files:

   ```bash
   sops updatekeys secrets/common.yaml
   sops updatekeys secrets/hosts/p14s.yaml
   ```

The system reads the host token and the user age identity from the host
file. It also reads service credentials from the common file. Both files
therefore need the laptop's host recipient in their encrypted metadata.

## Verify the Key and Update the Pin

Transfer the two encrypted YAML files to a private directory on the laptop
for verification. From the SSH session, change to that directory and enter a
Bash shell with the tools available:

```bash
nix --extra-experimental-features 'nix-command flakes' shell \
  nixpkgs#sops nixpkgs#ssh-to-age --command bash
```

With the files named `common.yaml` and `p14s.yaml`, run this check. Adjust
the host-key path to match the host module.

```bash
(
  set -o errexit -o pipefail
  decrypt_with() (
    unset SOPS_AGE_KEY_CMD SOPS_AGE_SSH_PRIVATE_KEY_FILE
    export SOPS_AGE_KEY="$1" SOPS_AGE_KEY_FILE=/dev/null
    shift
    sops decrypt "$@"
  )
  host_age_key=$(sudo cat /etc/ssh/ssh_host_ed25519_key |
    ssh-to-age -private-key)
  decrypt_with "$host_age_key" common.yaml >/dev/null
  user_age_key=$(decrypt_with "$host_age_key" \
    --extract '["keys"]["age"]' p14s.yaml)
  decrypt_with "$user_age_key" common.yaml >/dev/null
  echo 'Host and user decryption checks passed.'
)
```

After the corrected secrets revision is available on `nix-secrets/main`,
run the following in the workstation's `nix` checkout with authenticated
Nix access to GitHub:

```bash
nix flake update nix-secrets
jq -r '.nodes["nix-secrets"].locked.rev' flake.lock
```

Confirm that the pinned revision contains both tested encrypted files.
Include the new host module, hardware file, and updated lock file in the
`nix` revision you check out on the laptop. Git-backed flakes only see
files that Git tracks.

## Test from SSH and Set the Boot Default

Clone or update the `nix` checkout on the laptop using your normal GitHub
authentication. Git authentication and Nix's GitHub input authentication
are separate. Before the first privileged build, configure temporary
read access for the Nix client running as root to all private GitHub
inputs. The SOPS-generated token becomes available only after activation.
Keep bootstrap credentials outside both checkouts. If needed, set the
token for the rebuild in a Bash subshell. Use a token with read access
to the private inputs. Enter it at the prompt.

```bash
(
  read -r -s -p 'GitHub token: ' bootstrap_token
  printf '\n'
  export NIX_CONFIG="access-tokens = github.com=$bootstrap_token"
  unset bootstrap_token
  sudo --preserve-env=NIX_CONFIG nixos-rebuild test --flake .#p14s
)
```

Keep your current SSH session open. If you have not run the test with
the bootstrap token, run this from the laptop's `nix` checkout:

```bash
sudo nixos-rebuild test --flake .#p14s
```

Open a **new SSH connection over Tailscale from the workstation**:

```bash
ssh llee@p14s
```

In the new session, confirm that sudo works and check Tailscale and SOPS.
These commands assume `llee` is the configured primary user.

```bash
sudo -v
tailscale status
sudo test -s /run/secrets/tokens/github/repo_scope
test -r "$HOME/.config/sops/age/keys.txt"
systemctl --user status sops-nix.service
```

If the laptop needs to reauthenticate, run `sudo tailscale up` from
the laptop console or an
existing connection. Complete sign-in before testing a fresh connection.
See [Install Tailscale on Linux][tailscale-login].

If the test disrupts access, use the laptop console and reboot into the
previous boot generation. After the checks pass from the new session, set
the tested configuration as the boot default:

```bash
sudo nixos-rebuild switch --flake .#p14s
```

Reconnect once more and remove any temporary bootstrap credentials.

## References

- [Linux SOPS Module][linux-sops]
- [Home Manager SOPS Module][home-manager-sops]
- [NixOS Rebuild][nixos-rebuild]
- [Earlier Secrets Revision][earlier-revision]

[earlier-revision]: https://github.com/sheeeng/nix-secrets/commit/6f68f88f2eb45cda0aa9bee8d8572d2009f03b0d
[home-manager-sops]: ../home-manager/sops.nix
[linux-sops]: ../hosts/linux/sops.nix
[nixos-rebuild]: https://wiki.nixos.org/wiki/Nixos-rebuild
[tailscale-login]: https://tailscale.com/docs/install/linux
