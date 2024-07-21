{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.tmux;
  currentUser = config.people.myself;

  # we need to import the scripts for the sesseioniser
  tmux-sessioniser = pkgs.writeShellScriptBin "tmux-sessioniser" (builtins.readFile ./tmux-sessioniser);
in
  with lib; {
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
            sensibleOnTop = true;
            plugins = with pkgs; [
              # must be before continuum edits right status bar
              {
                plugin = tmuxPlugins.catppuccin;
                extraConfig = ''
                  set -g @catppuccin_flavour 'frappe'
                  set -g @catppuccin_window_tabs_enabled on
                  set -g @catppuccin_date_time "%H:%M"
                '';
              }

              {
                plugin = tmuxPlugins.resurrect;
                extraConfig = ''
                  set -g @resurrect-strategy-vim 'session'
                  set -g @resurrect-strategy-nvim 'session'
                  set -g @resurrect-capture-pane-contents 'on'
                '';
              }
              {
                plugin = tmuxPlugins.continuum;
                extraConfig = ''
                  set -g @continuum-restore 'on'
                  set -g @continuum-save-interval '10'
                '';
              }
              {
                plugin = tmuxPlugins.vim-tmux-navigator;
              }
            ];
            extraConfig = ''
              bind-key -r f run-shell "tmux neww tmux-sessioniser"
            '';
          };
        };
      };
    };
  }
