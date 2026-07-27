# https://github.com/RMTT/machines/blob/8a1d5a5c62e1e4e6b5e48184bc11960fce56fb24/home/modules/shell.nix
# _: { }

{ pkgs, ... }:
{
  programs.starship = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableFishIntegration
    enableInteractive = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableInteractive
    enableIonIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableIonIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableNushellIntegration
    enableTransience = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableTransience
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableZshIntegration
    package = pkgs.starship; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.package
    settings =
      let
        catppuccinTheme = pkgs.fetchFromGitHub {
          owner = "catppuccin"; # owner
          repo = "starship"; # repo
          rev = "5906cc369dd8207e063c0e6e2d27bd0c0b567cb8";
          sha256 = "0j3bc9caf6ayg7m8s0hshypgqiiy8bm9kakxwa5ackk955nf7c8l";
        };
      in
      builtins.fromTOML (builtins.readFile (catppuccinTheme + "/themes/mocha.toml"))
      // {
        "$schema" = "https://starship.rs/config-schema.json";
        palette = "catppuccin_mocha";
        add_newline = false;
        battery = {
          full_symbol = "🔋 ";
          charging_symbol = "⚡️ ";
          discharging_symbol = "💀 ";
        };
        erlang = {
          format = "via [e $version](bold red) ";
        };
        git_branch = {
          symbol = "🌱 ";
        };
        git_commit = {
          commit_hash_length = 4;
          tag_symbol = "🔖 ";
        };
        git_state = {
          format = "[($state($progress_current of $progress_total))]($style) ";
          cherry_pick = "[🍒 PICKING](bold red)";
        };
        git_status = {
          conflicted = "🏳";
          ahead = "🏎💨";
          behind = "😰";
          diverged = "😵";
          untracked = "🤷‍";
          stashed = "📦";
          modified = "📝";
          staged = "[++($count)](green)";
          renamed = "👅";
          deleted = "🗑";
        };
        hostname = {
          ssh_only = false;
          format = "on [$hostname](bold red) ";
          disabled = false;
        };
        nix_shell = {
          disabled = false;
          impure_msg = "[impure shell](bold red)";
          pure_msg = "[pure shell](bold green)";
          format = "via [☃️ $state( ($name))](bold blue) ";
        };
        shell = {
          disabled = false; # shows the active shell (bash/zsh/fish/nu/…)
          bash_indicator = "bash";
          zsh_indicator = "zsh";
          fish_indicator = "fish";
          nu_indicator = "nu";
          ion_indicator = "ion";
          unknown_indicator = "shell";
          format = "[$indicator]($style) ";
          style = "bold cyan";
        };
        terraform = {
          format = "[🏎💨 $version$workspace]($style) ";
        };
        username = {
          style_user = "white bold";
          style_root = "black bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
      }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.settings
  };
}
