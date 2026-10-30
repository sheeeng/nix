{
  config,
  inputs,
  pkgs,
  ...
}:
let
  privateIdentity = {
    signing.key = "1C07A2C9EE845600!";
    user = {
      email = "sheeeng@gmail.com";
      name = "Sheng Sheng Lee";
    };
  };
  workIdentity = inputs.nix-secrets.sheeeng;
in
{
  programs.jujutsu = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jujutsu.enable
    package = pkgs.jujutsu; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jujutsu.package
    settings = {
      "--scope" = [
        {
          "--when".repositories = [ "~/bitbucket" ];
          user = {
            email = workIdentity.email.private or "unknown.user@undefined.domain";
            name = workIdentity.userPreferredName or "Unknown User";
          };
        }
        (
          privateIdentity
          // {
            "--when".repositories = [
              "~/bitbucket/sheeeng"
              "~/codeberg"
              "~/dottir"
              "${config.xdg.configHome}/gitea"
              "${config.xdg.configHome}/srht"
            ];
          }
        )
        {
          "--when".repositories = [ "~/github" ];
          user.email = "305414+sheeeng@users.noreply.github.com";
        }
        {
          "--when".repositories = [ "~/github/sheeeng/vscodium-settings" ];
          user.name = "Sheng Sheng";
        }
        {
          "--when".repositories = [ "~/gitlab" ];
          user = {
            email = "1239077-sheeeng@users.noreply.gitlab.com";
            name = "Leonard Lee";
          };
        }
      ];
      signing = {
        backend = "gpg";
        backends.gpg.program = pkgs.lib.getExe' pkgs.gnupg "gpg2";
        behavior = "own";
        key = config.programs.git.signing.key;
      };
      user = {
        email = config.programs.git.settings.user.email;
        name = config.programs.git.settings.user.name;
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jujutsu.settings
  };
}
