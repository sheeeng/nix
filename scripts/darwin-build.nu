#!/usr/bin/env nu

def main [--update-flake] {
  cd $env.FILE_PWD # Move to the script directory so Git can locate the repository.
  cd (git rev-parse --show-toplevel) # Move to the repository root that Git reports.

  if $update_flake {
    nix flake update
  }

  (
    nix run github:lnl7/nix-darwin -- build
      --print-build-logs
      --show-trace
      --verbose
      --cores 0
      --max-jobs 8
      --flake $"($env.HOME)/github/sheeeng/nix"
      out+err>| nix run 'nixpkgs#nix-output-monitor'
  )
}
