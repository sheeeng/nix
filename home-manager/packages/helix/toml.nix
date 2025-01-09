{ ... }:
{
  programs.helix = {
    languages = {
      languages = [
        {
          name = "toml";
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
