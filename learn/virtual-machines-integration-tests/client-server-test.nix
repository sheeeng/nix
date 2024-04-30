# https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.testers.runNixOSTest {
  name = "client-server-test";

  nodes.server = { pkgs, ... }: {
    networking = {
      firewall = {
        allowedTCPPorts = [ 80 ];
      };
    };
    services.nginx = {
      enable = true;
      virtualHosts."server" = {};
    };
  };

  nodes.client = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      curl
    ];
  };

  testScript = ''
    server.wait_for_unit("default.target")
    client.wait_for_unit("default.target")
    client.succeed("curl http://server/ | grep -o \"Welcome to nginx!\"")
  '';
}
