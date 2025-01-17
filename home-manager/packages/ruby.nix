{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bundix
    jekyll
    (ruby.withPackages (
      pkgs: with pkgs; [
        bundler
        nokogiri
        rouge
      ]
    ))
  ];
}
