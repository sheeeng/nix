# README

```shell
git config --unset-all remote.origin.pushurl; \
git remote set-url origin git@github.com:sheeeng/nix.git \
&& git remote set-url --add --push origin git@git.sr.ht:~sheeeng/nix \
&& git remote set-url --add --push origin git@gitea.com:sheeeng/nix.git \
&& git remote set-url --add --push origin git@github.com:sheeeng/nix.git \
&& git remote set-url --add --push origin git@gitlab.com:sheeeng/nix.git \
&& git remote set-url --add --push origin ssh://git@codeberg.org/sheeeng/nix.git
```

```shell
git push git@git.sr.ht:~sheeeng/nix
git push git@gitea.com:sheeeng/nix.git
git push git@github.com:sheeeng/nix.git
git push git@gitlab.com:sheeeng/nix.git
git push ssh://git@codeberg.org/sheeeng/nix.git
```

```shell
git ls-remote --heads git@git.sr.ht:~sheeeng/nix
git ls-remote --heads git@gitea.com:sheeeng/nix.git
git ls-remote --heads git@gitlab.com:sheeeng/nix.git
git ls-remote --heads git@gitlab.com:sheeeng/nix.git
git ls-remote --heads ssh://git@codeberg.org/sheeeng/nix.git
```

```shell
git push --delete git@git.sr.ht:~sheeeng/nix ci/standardize-workflows
git push --delete git@gitea.com:sheeeng/nix.git ci/standardize-workflows
git push --delete git@github.com:sheeeng/nix.git ci/standardize-workflows
git push --delete git@gitlab.com:sheeeng/nix.git ci/standardize-workflows
git push --delete ssh://git@codeberg.org/sheeeng/nix.git ci/standardize-workflows
```
