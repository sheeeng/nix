# README

```shell
nix-shell \
--packages cowsay lolcat \
--run "cowsay Hello, Nix! | lolcat"
```

```shell
nix-shell --packages cowsay --run "cowsay Nix\!"
```

```shell
nix-shell --packages hello --run hello
```

```shell
nix-shell --packages git neovim nodejs
```

```shell
nix-shell --packages hello --run 'nix-shell -p python3 --run "python --version"'
```

```shell
nix-shell --packages git --run "git --version" --pure -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz
```
