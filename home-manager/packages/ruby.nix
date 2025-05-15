{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bundix # https://search.nixos.org/packages?channel=unstable&type=packages&show=bundix
    # bundler # https://search.nixos.org/packages?channel=unstable&type=packages&show=bundler
    # jekyll # https://search.nixos.org/packages?channel=unstable&type=packages&show=jekyll
    (ruby.withPackages (
      pkgs: with pkgs; [
        github-pages # https://search.nixos.org/packages?channel=unstable&type=packages&show=rubyPackages.github-pages
        jekyll-theme-minimal # https://search.nixos.org/packages?channel=unstable&type=packages&show=rubyPackages.jekyll-theme-minimal
        nokogiri # https://search.nixos.org/packages?channel=unstable&type=packages&show=rubyPackages.nokogiri
        rouge # https://search.nixos.org/packages?channel=unstable&type=packages&show=rubyPackages.rouge
      ]
    ))
  ];
}
