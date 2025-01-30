{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    comrak # Markdown formatter & HTML converter
    glow # Fancy Markdown renderer CLI
    mandown # Markdown to groff (manpage) converter
    marked-man # Markdown to roff
    md-tui # Markdown TUI renderer
    md2pdf # Markdown to PDF conversion tool
    mdbook # Create books from Markdown.
    mdcat # cat for Markdown
    mdctags # Markdown file tags
    mdr # Markdown Renderer
    mdsh # Markdown shell pre-processor
    papeer # Convert websites into ebooks & Markdown
    ronn # Markdown-based tool for building manpages
  ];

  programs.helix = {
    # extraPackages = [
    #   pkgs.comrak
    #   pkgs.markdown-oxide
    #   pkgs.marksman
    #   pkgs.mdctags
    #   pkgs.mdformat
    # ]; # FIXME: error: collision between `/nix/store/jbympkpfxd2j2qnncsk5rfrkwr9xqpdx-helix-wrapped-24.07/bin/hx' and `/nix/store/k7qpx67xhgmkvvgb2fpwdy611cw98nx4-helix-24.07/bin/hx'
    languages = {
      language = [
        {
          name = "markdown";
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.deno; # https://search.nixos.org/packages?channel=unstable&type=packages&show=deno
            args = [
              "fmt"
              "-"
              "--ext"
              "md"
            ];
          };
          # formatter = {
          #   command = lib.getExe pkgs.gnused; # https://search.nixos.org/packages?channel=unstable&type=packages&show=gnused
          #   args = [ "s/[[:space:]]*$//" ];
          # }; # Remove trailing whitespaces. https://www.reddit.com/r/HelixEditor/comments/1c9lg73/highlight_trailing_whitespace_only/
          language-servers = [
            "ltex-ls"
            "markdown-oxide"
            "marksman"
          ];
        }
      ];
      language-server = {
        ltex-ls = {
          command = lib.getExe pkgs.ltex-ls; # https://search.nixos.org/packages?channel=unstable&type=packages&show=ltex-ls
          config = {
            ltex.disabledRules = {
              en-US = [ "PROFANITY" ];
              en-GB = [ "PROFANITY" ];
            };
            ltex.dictionary = {
              en-US = [ "builtin" ];
              en-GB = [ "builtin" ];
            };
          };
        };
        markdown-oxide = {
          command = lib.getExe pkgs.markdown-oxide; # https://search.nixos.org/packages?channel=unstable&type=packages&show=markdown-oxide
        };
        marksman = {
          command = lib.getExe pkgs.marksman; # https://search.nixos.org/packages?channel=unstable&type=packages&show=marksman
          args = [ "server" ];
        };
        # mdpls = {
        #   command = lib.getExe pkgs.mdpls; # TODO FIXME: https://search.nixos.org/packages?channel=unstable&type=packages&show=mdpls
        #   config.markdown.preview = {
        #     auto = true; # Automatically open preview in browser when opening file
        #     serveStatic = true; # Show images
        #   };
        # }; # https://github.com/euclio/mdpls
      };
    };
  };
}
