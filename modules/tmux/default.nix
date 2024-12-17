{ config, lib, pkgs, ... }:
let
  cfg = config.modules.tmux;
  currentUser = config.people.myself;

  # we need to import the scripts for the sesseioniser
  tmux-sessioniser = pkgs.writeShellScriptBin "tmux-sessioniser"
    (builtins.readFile ./tmux-sessioniser);

  kanagawa = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "kanagawa";
    version = "unstable-2024-10-09";
    src = pkgs.fetchFromGitHub {
      owner = "Nybkox";
      repo = "tmux-kanagawa";
      rev = "fc95d797ba24536bffe3f2b2101e7d7ec3e5aaa1";
      sha256 = "sha256-vCgqXrT7qukAmx/DUu4H6CT997pdiKOKA0CjLTWEALQ=";
    };
  };
  tmux-powerline = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-powerline";
    name = "tmux-powerline";
    src = pkgs.fetchFromGitHub {
      owner = "erikw";
      repo = "tmux-powerline";
      rev = "e214721694661448176580433fd563f82542545a";
      sha256 = "0f9xwlnjwsy7b8w76j5pg9hd0s01vwry574jfg4pi2lc3hbjkab5";
    };
  };
in with lib; {
  options.modules.tmux = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    mainWorkspaceDir = mkOption {
      default = "$HOME/workspace";
      type = types.str;
      description = "directory for prefix+m to point to";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${currentUser} = {
      home = {
        packages = [
          # and add custom scripts as packages
          tmux-sessioniser
        ];
      };
      programs = {
        tmux = {
          enable = true;
          shell = "${pkgs.zsh}/bin/zsh";
          shortcut = "q";
          terminal = "tmux-256color";
          historyLimit = 100000;
          keyMode = "vi";
          escapeTime = 10;
          plugins = with pkgs; [
            # must be before continuum edits right status bar
            # {
            #   plugin = tmuxPlugins.catppuccin;
            #   extraConfig = ''
            #     set -g @catppuccin_flavour 'frappe'
            #     set -g @catppuccin_window_tabs_enabled on
            #     set -g @catppuccin_date_time "%H:%M"
            #   '';
            # }

            tmuxPlugins.vim-tmux-navigator
            tmuxPlugins.yank
            tmuxPlugins.sensible

            {

              plugin = kanagawa;
              extraConfig = ''
                set -g @kanagawa-plugins "git battery  cpu-usage ram-usage time"
                set -g @kanagawa-show-powerline true
                set -g @kanagawa-show-weather true
                set -g @kanagawa-show-weather-location "Frankfurt"
                set -g @kanagawa-theme "dragon"
                set -g @kanagawa-ignore-window-colors true
                set -g @kanagawa-day-month true
                set -g @kanagawa-git-no-repo-message ""
                set -g @kanagawa-time-format "%F %R"
                set -g @kanagawa-show-fahrenheit false
                # set -g @kanagawa-ignore-window-colors tru
              '';

            }

          ];
          extraConfig = ''
            bind-key -r f run-shell "tmux neww tmux-sessioniser"
            set-option -g default-command zsh


            # Refresh tmux conf
            unbind r
            bind r source-file ~/.config.tmux/tmux.conf
          '';
        };
      };
    };
  };
}
