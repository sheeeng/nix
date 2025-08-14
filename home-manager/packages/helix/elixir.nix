_: {
  # error: builder for '/nix/store/38fj8wxnxkhc2wx1cv2xpvqmj4bhypkf-home-manager-path.drv' failed with exit code 25;
  #   last 5 log lines:
  #   > pkgs.buildEnv error: two given paths contain a conflicting subpath:
  #   >   `/nix/store/1mr6pc7cwwaah24ijqfb8ws8nf7rjj3k-elixir-ls-0.28.1/LICENSE' and
  #   >   `/nix/store/qg8nfb53bvzj7br9xhw1wphpvi66dbaz-prettier-3.5.3/LICENSE'
  #   > hint: this may be caused by two different versions of the same package in buildEnv's `paths` parameter
  #   > hint: `pkgs.nix-diff` can be used to compare derivations
  #   For full logs, run:
  #     nix log /nix/store/38fj8wxnxkhc2wx1cv2xpvqmj4bhypkf-home-manager-path.drv

  # home.packages = with pkgs; [
  #   beam.packages.erlang.elixir-ls # https://search.nixos.org/packages?channel=unstable&type=packages&show=elixir-ls
  # ];

  # programs.helix.languages = {
  #   language = [
  #     {
  #       name = "elixir";
  #       indent = {
  #         tab-width = 2;
  #         unit = "\t";
  #       };
  #       auto-format = true;
  #       comment-token = "#";
  #       file-types = [
  #         "ex"
  #         "exs"
  #       ];
  #       roots = [ "mix.exs" ];
  #     }
  #   ];
  #   language-server = {
  #     elixir-ls = {
  #       command = lib.getExe pkgs.elixir-ls; # https://search.nixos.org/packages?channel=unstable&type=packages&show=elixir-ls
  #     };
  #   };
  # };
}
