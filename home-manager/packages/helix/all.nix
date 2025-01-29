{ ... }:
{
  home.packages = [ ];

  programs.helix = {
    # languages = {
    #   language = {
    #     name = "all";
    #     scope = "";
    #     file-types = [ { glob = "*"; } ];
    #   }; # TODO: https://github.com/helix-editor/helix/issues/9165#issuecomment-2310454339
    #   language-server = { };
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.languages
  };
}
