# nix

## ~~Installation~~

```shell
git submodule init
git submodule update
ln --symbolic $(pwd) ~/.config/nixpkgs
nix-env --set-flag priority 0 nix-2.22.0
nix-env -f '<nixpkgs>' -iA home-manager
```

## Information

- Get information about Nix.

```shell
nix-shell \
--packages nix-info \
--run "nix-info --markdown --sandbox --host-os"
```

- Check which Nix version will be installed. For example, `nixpkgs-unstable` from the [release channels](http://channels.nixos.org/).

```shell
nix-shell \
--packages nix \
-I nixpkgs=channel:nixpkgs-unstable \
--run "nix --version"
```

## [Garbage Collection](https://nixos.org/manual/nix/stable/package-management/garbage-collection)

```shell
nix-env --delete-generations old \
&& nix-store --gc --print-dead \
&& nix-collect-garbage --delete-old
```

## [Dummy Store](https://nixos.org/manual/nix/stable/store/types/dummy-store)

```console
$ nix eval --store dummy:// --expr '1 + 2'
error: experimental Nix feature 'nix-command' is disabled; add '--extra-experimental-features nix-command' to enable it
```

```shell
nix --extra-experimental-features \
nix-command eval --store dummy:// --expr '1 + 2'
```

## Miscellaneous

<https://nixos.org/guides/nix-pills/06-our-first-derivation.html#digression-about-drv-files>

```shell
nix show-derivation --extra-experimental-features \
nix-command $(find /nix/store -maxdepth 1 -name '\*.drv' | head -n 1)
```

```console
$ time nix run nixpkgs#bash -- -c 'exit 0'
error: experimental Nix feature 'nix-command' is disabled; add '--extra-experimental-features nix-command' to enable it
nix run nixpkgs#bash -- -c 'exit 0'  0.03s user 0.02s system 23% cpu 0.225 total
```

```shell
time nix run nixpkgs#bash -- -c 'exit 0'
time nix run nixpkgs#fish -- -c 'exit 0'
```

- Enable `nix *` commands and flakes.

```console
$ bat /etc/nix/nix.conf | grep nix-command
experimental-features = nix-command flakes
```

```console
$ nix build nixpkgs#nixos-manual-epub
error: experimental Nix feature 'nix-command' is disabled; add '--extra-experimental-features nix-command' to enable it
$ nix \
--extra-experimental-features flakes \
--extra-experimental-features nix-command \
build nixpkgs#nixos-manual-epub
```

## References

- <https://nixos.org/manual/nix/stable/introduction>
- <https://nixos.org/manual/nix/unstable/introduction>
- <https://nix-community.github.io/home-manager/>
- <https://nix-community.github.io/home-manager/options.xhtml>
- <https://nixos.wiki/wiki/Main_Page>
- <https://nixos.wiki/wiki/Home_Manager>
- <https://ianthehenry.com/posts/how-to-learn-nix/>
- <https://nixos.org/guides/nix-pills/>
- <https://nix.dev/>
- <https://nix.dev/tutorials/first-steps/declarative-shell.html#a-basic-shell-nix-file>
- <https://blog.wesleyac.com/posts/the-curse-of-nixos>
- <https://nixos.wiki/wiki/Cheatsheet>
- <https://nixos.wiki/wiki/Resources>
- <https://nixos.org/learn/>
