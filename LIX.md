# LIX

```shell
curl --silent --show-error --fail --location https://install.lix.systems/lix | sh -s -- install
```

```console
$ curl --silent --show-error --fail --location https://install.lix.systems/lix | sh -s -- install
info: downloading installer https://install.lix.systems/lix/lix-installer-aarch64-darwin
`lix-installer` needs to run as `root`, attempting to escalate now via `sudo`...


Welcome to the Lix installer! Just a couple of quick questions.

Flakes are an experimental feature, but widely used in the community.
You can change this later in `/etc/nix/nix.conf`.

Enable flakes? ([Y]es/[n]o): Y

QUICK NOTE: we've enabled the experimental nix command for you!
Be aware that commands starting with `nix ` such as `nix build` may change syntax.

Lix install plan (v0.17.1)
Planner: macos (with default settings)

Planned actions:
* Create an encrypted APFS volume `Nix Store` for Nix on `disk3` and add it to `/etc/fstab` mounting on `/nix`
* Fetch `https://releases.lix.systems/lix/lix-2.91.1/lix-2.91.1-aarch64-darwin.tar.xz` to `/nix/temp-install-dir`
* Create a directory tree in `/nix`
* Move the downloaded Nix into `/nix`
* Create build users (UID 351-382) and group (GID 350)
* Configure Time Machine exclusions
* Setup the default Nix profile
* Place the Nix configuration in `/etc/nix/nix.conf`
* Configure the shell profiles
* Configuring zsh to support using Nix in non-interactive shells
* Create a `launchctl` plist to put Nix into your PATH
* Configure Nix daemon related settings with launchctl
* Remove directory `/nix/temp-install-dir`


Proceed? ([Y]es/[n]o/[e]xplain): Y
 INFO Step: Create an encrypted APFS volume `Nix Store` for Nix on `disk3` and add it to `/etc/fstab` mounting on `/nix`
 INFO Step: Provision Nix
 INFO Step: Create build users (UID 351-382) and group (GID 350)
 INFO Step: Configure Time Machine exclusions
 INFO Step: Configure Nix
 INFO Step: Configuring zsh to support using Nix in non-interactive shells
 INFO Step: Create a `launchctl` plist to put Nix into your PATH
 INFO Step: Configure Nix daemon related settings with launchctl
 INFO Step: Remove directory `/nix/temp-install-dir`
Nix was installed successfully!
To get started using Nix, open a new shell or run `. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`
```

```console
$ nix run nix-darwin --experimental-features "nix-command flakes" -- switch --flake ~/.config/nix
building the system configuration...
warning: Git tree '/Users/leonardlee/.config/nix' is dirty
warning: updating lock file '/Users/leonardlee/.config/nix/flake.lock':
• Updated input 'nixpkgs':
    'github:nixos/nixpkgs/85f7e662eda4fa3a995556527c87b2524b691933' (2024-11-07)
  → 'github:nixos/nixpkgs/a53cfe5e6e9fb28b1442b2b6a9fd577d8d64c6d6' (2024-12-19)
warning: Git tree '/Users/leonardlee/.config/nix' is dirty
user defaults...
setting up user launchd services...
setting up /Applications/Nix Apps...
setting up pam...
applying patches...
setting up /etc...
system defaults...
setting up launchd services...
creating service org.nixos.activate-system
reloading service org.nixos.nix-daemon
reloading nix-daemon...
waiting for nix-daemon
waiting for nix-daemon
configuring networking...
configuring power...
setting up /Library/Fonts/Nix Fonts...
setting nvram variables...
```

```console
$ nix run nix-darwin -- switch --flake ~/.config/nix
building the system configuration...
warning: Git tree '/Users/leonardlee/.config/nix' is dirty
user defaults...
setting up user launchd services...
setting up /Applications/Nix Apps...
setting up pam...
applying patches...
setting up /etc...
system defaults...
setting up launchd services...
reloading nix-daemon...
waiting for nix-daemon
configuring networking...
configuring power...
setting up /Library/Fonts/Nix Fonts...
setting nvram variables...
```

```shell
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```
