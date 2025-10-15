{ pkgs, ... }:

let
  cfg = {
    indent = {
      tab-width = 2;
      unit = "\t";
    };
    auto-format = true;

    language-servers = [
      "typescript-language-server"
      "eslint"
    ];
  };

  lspBinPath =
    lang:
    with pkgs.nodePackages;

    if lang == "typescript" then
      "${typescript-language-server}/bin/typescript-language-server"
    else
      "${vscode-langservers-extracted}/bin/vscode-${lang}-language-server";
in

{
  home.packages = with pkgs.nodePackages; [
    typescript-language-server
    vscode-langservers-extracted
  ];

  programs.helix = {
    languages = {
      language = [
        (
          cfg
          // {
            name = "html";
            scope = "text.html.basic";
            file-types = [
              "html"
              "htm"
            ];
            language-servers = [ "vscode-html-language-server" ];
          }
        )
        (
          cfg
          // {
            name = "css";
            scope = "source.css";
            file-types = [ "css" ];
            language-servers = [ "vscode-css-language-server" ];
          }
        )
        (
          cfg
          // {
            name = "scss";
            scope = "source.scss";
            file-types = [
              "scss"
              "sass"
            ];
            language-servers = [ "vscode-css-language-server" ];
          }
        )
        (
          cfg
          // {
            name = "json";
            scope = "source.json";
            file-types = [
              "json"
              "jsonc"
            ];
            language-servers = [ "vscode-json-language-server" ];
          }
        )
        (
          cfg
          // {
            name = "tsx";
            scope = "source.tsx";
            file-types = [ "tsx" ];
          }
        )
        (
          cfg
          // {
            name = "typescript";
            scope = "source.ts";
            file-types = [ "ts" ];
          }
        )
        (
          cfg
          // {
            name = "jsx";
            scope = "source.jsx";
            file-types = [ "jsx" ];
          }
        )
        (
          cfg
          // {
            name = "javascript";
            scope = "source.js";
            file-types = [
              "js"
              "mjs"
              "cjs"
            ];
          }
        )
      ];

      language-server = {
        typescript-language-server.command = lspBinPath "typescript";
        vscode-css-language-server.command = lspBinPath "css";
        vscode-html-language-server.command = lspBinPath "html";
        vscode-json-language-server.command = lspBinPath "json";

        eslint = {
          args = [ "--stdio" ];
          command = lspBinPath "eslint";
          config = {
            format = true;
            nodePath = "";
            onIgnoredFiles = "off";
            packageManager = "npm";
            quiet = false;
            rulesCustomizations = [ ];
            run = "onType";
            useESLintClass = false;
            validate = "on";
            codeAction = {
              disableRuleComment = {
                enable = true;
                location = "separateLine";
              };
              showDocumentation.enable = true;
            };
            codeActionOnSave.mode = "all";
            experimental = { };
            problems.shortenToSingleLine = false;
            workingDirectory.mode = "auto";
          };
        };
      };
    };
  };
}
