# Ollama — local LLM server (launchd agent on macOS, systemd on Linux)
#
# After `darwin-rebuild switch --flake .`, pull a Gemma 3 model:
#   ollama pull gemma3       # 4b by default (~2.5 GB)
#   ollama pull gemma3:1b    # ~815 MB  — fastest, least RAM
#   ollama pull gemma3:4b    # ~2.5 GB  — good balance
#   ollama pull gemma3:12b   # ~7.5 GB  — better quality
#   ollama pull gemma3:27b   # ~16 GB   — best quality, needs ~32 GB RAM
#
# Chat interactively:
#   ollama run gemma3
#
# REST API (OpenAI-compatible) at http://127.0.0.1:11434:
#   curl http://localhost:11434/api/generate \
#     -d '{"model":"gemma3","prompt":"Hello"}'
#
# List downloaded models:  ollama list
# Remove a model:          ollama rm gemma3:1b
{ pkgs, ... }:
{
  services.ollama = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.ollama.enable
    package = pkgs.ollama; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.ollama.package
    acceleration = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.ollama.acceleration
    environmentVariables = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.ollama.environmentVariables
    host = "127.0.0.1"; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.ollama.host
    port = 11434; # https://nix-community.github.io/home-manager/options.xhtml#opt-services.ollama.port
  };
}
