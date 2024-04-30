# README

<https://fzakaria.com/2021/08/02/a-minimal-nix-shell.html>

## Getting Started

```shell
time nix-shell --verbose mkshell.nix --run "exit"
nix-store --query --graph \
    $(nix-build --no-out-link --attr inputDerivation mkshell.nix)
nix path-info \
    --closure-size \
    --human-readable \
    $(nix-build --no-out-link --attr inputDerivation mkshell.nix)
# error: experimental Nix feature 'nix-command' is disabled; add '--extra-experimental-features nix-command' to enable it
nix --extra-experimental-features nix-command \
    path-info \
    --closure-size \
    --human-readable \
    $(nix-build --no-out-link --attr inputDerivation mkshell.nix)
```

```shell
time nix-shell --verbose mkshellnocc.nix --run "exit"
nix-store --query --graph \
    $(nix-build --no-out-link --attr inputDerivation mkshellnocc.nix)
nix path-info \
    --closure-size \
    --human-readable \
    $(nix-build --no-out-link --attr inputDerivation mkshellnocc.nix)
# error: experimental Nix feature 'nix-command' is disabled; add '--extra-experimental-features nix-command' to enable it
nix --extra-experimental-features nix-command \
    path-info \
    --closure-size \
    --human-readable \
    $(nix-build --no-out-link --attr inputDerivation mkshellnocc.nix)
```

```shell
time nix-shell --verbose mkshellminimal.nix --run "exit"
nix-store --query --graph \
    $(nix-build --no-out-link --attr inputDerivation mkshellminimal.nix)
nix path-info \
    --closure-size \
    --human-readable \
    $(nix-build --no-out-link --attr inputDerivation mkshellminimal.nix)
# error: experimental Nix feature 'nix-command' is disabled; add '--extra-experimental-features nix-command' to enable it
nix --extra-experimental-features nix-command \
    path-info \
    --closure-size \
    --human-readable \
    $(nix-build --no-out-link --attr inputDerivation mkshellminimal.nix)
du --human-readable /nix/store/6pjfamqp12k2l70wfgirl1x4ghvi82kk-mkshellminimal | sort --reverse --human-numeric-sort | head --lines 10
```

```

```
