{ pkgs, lib, ... }:
let
  pkg = pkgs.nodePackages.prettier;

  prettier = parser: {
    command = "${pkg}/bin/prettier";
    args = lib.flatten [
      [
        "--parser"
        parser
      ]

      # Prefer project-specific config file over the options defined below.
      [
        "--config-precedence"
        "prefer-file"
      ]

      # Formating Options:
      [ "--use-tabs" ]
      [
        "--tab-width"
        "2"
      ]
      [
        "--print-width"
        "80"
      ]
      [
        "--quote-prop"
        "consistent"
      ]
      [
        "--prose-wrap"
        "always"
      ]
    ];
  };
in
{
  home.packages = [ pkg ];

  programs.helix = {
    languages = {
      language = [
        {
          name = "html";
          scope = "text.html.basic";
          file-types = [
            "html"
            "htm"
          ];
          formatter = prettier "html";
        }
        {
          name = "css";
          scope = "source.css";
          file-types = [ "css" ];
          formatter = prettier "css";
        }
        {
          name = "jsx";
          scope = "source.jsx";
          file-types = [ "jsx" ];
          formatter = prettier "typescript";
        }
        {
          name = "tsx";
          scope = "source.tsx";
          file-types = [ "tsx" ];
          formatter = prettier "typescript";
        }
        {
          name = "javascript";
          scope = "source.js";
          file-types = [
            "js"
            "mjs"
            "cjs"
          ];
          formatter = prettier "typescript";
        }
        {
          name = "typescript";
          scope = "source.ts";
          file-types = [ "ts" ];
          formatter = prettier "typescript";
        }
        {
          name = "json";
          scope = "source.json";
          file-types = [
            "json"
            "jsonc"
          ];
          formatter = prettier "json";
        }
        {
          name = "yaml";
          scope = "source.yaml";
          file-types = [
            "yaml"
            "yml"
          ];
          formatter = prettier "yaml";
        }
        {
          name = "markdown";
          scope = "text.html.markdown";
          file-types = [
            "md"
            "markdown"
          ];
          formatter = prettier "markdown";
        }
        {
          name = "graphql";
          scope = "source.graphql";
          file-types = [
            "gql"
            "graphql"
          ];
          formatter = prettier "graphql";
        }
      ];
    };
  };
}
