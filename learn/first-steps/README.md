# README

```shell
nix-shell \
--packages cowsay lolcat \
--run "cowsay Hello, Nix! | lolcat"
```

```shell
nix-shell --packages hello --run hello
```

```shell
nix-shell --packages git neovim nodejs
```
