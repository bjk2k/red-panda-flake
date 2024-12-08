{ config, lib, pkgs, ... }:
let
  cfg = config.modules.tmux;
  currentUser = config.people.myself;

  # we need to import the scripts for the sesseioniser
  tmux-sessioniser = pkgs.writeShellScriptBin "tmux-sessioniser"
    (builtins.readFile ./tmux-sessioniser);
  # tmux kanagawa plugin
  tmux-kanagawa = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-kanagawa";

    version = "unstable-2024-12-05";
    src = pkgs.fetchFromGitHub {
      owner = "Nybkox";
      repo = "tmux-kanagawa";
      rev = "0d2db8d95e1b74643a06802043c7000a79ba0a0a";
      sha256 = "sha256-ymmCI6VYvf94Ot7h2GAboTRBXPIREP+EB33+px5aaJk=";
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
          sensibleOnTop = true;
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

            # {
            #   plugin = tmux-kanagawa;
            #
            #   extraConfig = ''
            #     set -g @kanagawa-ignore-window-colors true
            #     set -g @kanagawa-theme 'dragon'
            #   '';
            # }
            # {
            #   plugin = tmuxPlugins.nord;
            # }
            {
              plugin = tmuxPlugins.logging;
              extraConfig = ''
                  set -g @logging-path "$HOME/.tmux-logging"
                  set -g @logging-level "INFO"
                 set -g @rose-pine-variant 'main'

                set -g @rose_pine_host 'on' # Enables hostname in the status bar
                set -g @rose_pine_user 'on' # Turn on the username component in the statusbar
                set -g @rose_pine_directory 'on' # Turn on the current folder component in the status bar
                set -g @rose_pine_bar_bg_disable 'on' # Disables background color, for transparent terminal emulators
                # If @rose_pine_bar_bg_disable is set to 'on', uses the provided value to set the background color
                # It can be any of the on tmux (named colors, 256-color set, `default` or hex colors)
                # See more on http://man.openbsd.org/OpenBSD-current/man1/tmux.1#STYLES
                set -g @rose_pine_bar_bg_disabled_color_option 'default'

                set -g @rose_pine_only_windows 'on' # Leaves only the window module, for max focus and space
                set -g @rose_pine_disable_active_window_menu 'on' # Disables the menu that shows the active window on the left

                set -g @rose_pine_default_window_behavior 'on' # Forces tmux default window list behaviour
                set -g @rose_pine_show_current_program 'on' # Forces tmux to show the current running program as window name
                set -g @rose_pine_show_pane_directory 'on' # Forces tmux to show the current directory as window name
                # Previously set -g @rose_pine_window_tabs_enabled

                # Example values for these can be:
                set -g @rose_pine_left_separator ' > ' # The strings to use as separators are 1-space padded
                set -g @rose_pine_right_separator ' < ' # Accepts both normal chars & nerdfont icons
                set -g @rose_pine_field_separator ' | ' # Again, 1-space padding, it updates with prefix + I
                set -g @rose_pine_window_separator ' - ' # Replaces the default `:` between the window number and name

                # These are not padded
                set -g @rose_pine_session_icon '' # Changes the default icon to the left of the session name
                set -g @rose_pine_current_window_icon '' # Changes the default icon to the left of the active window name
                set -g @rose_pine_folder_icon '' # Changes the default icon to the left of the current directory folder
                set -g @rose_pine_username_icon '' # Changes the default icon to the right of the hostname
                set -g @rose_pine_hostname_icon '󰒋' # Changes the default icon to the right of the hostname
                set -g @rose_pine_date_time_icon '󰃰' # Changes the default icon to the right of the date module
                set -g @rose_pine_window_status_separator "  " # Changes the default icon that appears between window names

                # Very beta and specific opt-in settings, tested on v3.2a, look at issue #10
                set -g @rose_pine_prioritize_windows 'on' # Disables the right side functionality in a certain window count / terminal width
                set -g @rose_pine_width_to_hide '80' # Specify a terminal width to toggle off most of the right side functionality
                set -g @rose_pine_window_count '5' # Specify a number of windows, if there are more than the number, do the same as width_to_hide

              '';

            }
            { plugin = tmuxPlugins.rose-pine; }
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
                set -g @continuum-restore 'off'
                set -g @continuum-save-interval '10'
              '';
            }
            { plugin = tmuxPlugins.vim-tmux-navigator; }
          ];
          extraConfig = ''
            bind-key -r f run-shell "tmux neww tmux-sessioniser"
            set-option -g default-command zsh


          '';
        };
      };
    };
  };
}
