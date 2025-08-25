# https://github.com/RMTT/machines/blob/8a1d5a5c62e1e4e6b5e48184bc11960fce56fb24/home/modules/shell.nix
# _: { }

{ lib, pkgs, ... }:
{
  programs.starship = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
    enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableBashIntegration
    enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableFishIntegration
    enableInteractive = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableInteractive
    enableIonIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableIonIntegration
    enableNushellIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableNushellIntegration
    enableTransience = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableTransience
    enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enableZshIntegration
    package = pkgs.starship; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.package
    settings = {
      add_newline = false;
      battery = {
        full_symbol = "🔋 ";
        charging_symbol = "⚡️ ";
        discharging_symbol = "💀 ";
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
        format = "on [work-box](bold red) ";
        disabled = false;
      };
      format = lib.concatStrings [
        "$battery"
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$git_state"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      # format = lib.concatStrings [
      #   "$line_break"
      #   "$package"
      #   "$line_break"
      #   "$character"
      # ];
      nix_shell = {
        disabled = false;
        impure_msg = "[impure shell](bold red)";
        pure_msg = "[pure shell](bold green)";
        format = "via [☃️ $state( ($name))](bold blue) ";
      };
      sudo = {
        style = "bold green";
        symbol = "🧙 ";
        disabled = true;
      };
      scan_timeout = 10;
      character = {
        # success_symbol = "➜";
        # error_symbol = "➜";
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
        vimcmd_symbol = "[<](bold green)";
        vimcmd_replace_one_symbol = "[<](bold purple)";
        vimcmd_replace_symbol = "[<](bold purple)";
        vimcmd_visual_symbol = "[<](bold yellow)";
      };
      package.disabled = false;
      gcloud.disabled = false;
      kubernetes.disabled = false;
      "$schema" = "https://starship.rs/config-schema.json";
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
