_: {
  programs.helix = {
    languages = {
      language = [
        {
          name = "toml";
          scope = "source.toml";
          file-types = [ "toml" ];
          language-servers = [ "taplo" ];
          formatter = {
            command = "taplo";
            args = [
              "fmt"
              "-o"
              "column_width=120"
              "-"
            ];
          };
          auto-format = true;
        }
      ];
      language-server = { };
    };
  };
}
