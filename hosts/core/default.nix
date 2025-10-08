# Core utilities for host configurations
{ lib, ... }:

{
  determinate = import ./determinate.nix { inherit lib; };
}
