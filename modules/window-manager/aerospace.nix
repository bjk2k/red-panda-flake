# this module aims to create a linuxy window-manager-like experience on macos
# Inspired by:
{ config, lib, pkgs, ... }:
with lib;
let
  # to escape $ propertly, config uses that create fsspace
  cfg = config.modules.window-manager.aerospace;

  sketchybarConfigLua = pkgs.callPackage ./sketchybar { };

  sbarLua = pkgs.callPackage ./sketchybar/helpers/sbar.nix { };

  lua = pkgs.lua54Packages.lua.withPackages
    (ps: [ ps.lua sbarLua sketchybarConfigLua ]);

  sbar_menus = pkgs.callPackage ./sketchybar/helpers/menus { };
  sbar_events = pkgs.callPackage ./sketchybar/helpers/event_providers { };
in {
  # add the aerospace pkg

  options.modules.window-manager.aerospace = {
    enable = mkEnableOption "aerospace";
    enableJankyborders = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      # --- [ Fonts ] ---
      fonts.packages = with pkgs; [
        # --- [ Fira Code ] ---
        sketchybar-app-font
        sf-symbols
      ];

      home-manager.users.${config.people.myself} = {
        xdg.configFile."sketchybar".source = ./sketchybar;
      };

      services = {
        # --- [ SketchyBar ] ---
        sketchybar = {
          extraPackages = [
            sbar_menus
            sbar_events
            lua
            pkgs.ripgrep
            pkgs.sbarlua
            pkgs.lua5_4
          ];
          enable = true;

          config = ''
            #!${lua}/bin/lua
                    package.cpath = package.cpath .. ";${lua}/lib/?.so"
                    require("init")
          '';
        };

        aerospace = {
          enable = true;
          package = pkgs.aerospace;
          settings = {
            gaps = {
              outer.top = 44;
              outer.right = 6;
              outer.bottom = 8;
              outer.left = 6;
              inner.horizontal = 6;
              inner.vertical = 6;
            };

            enable-normalization-flatten-containers = true;
            enable-normalization-opposite-orientation-for-nested-containers =
              true;
            accordion-padding = 30;
            exec-on-workspace-change = [
              "/bin/bash"
              "-c"
              "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
            ];

            default-root-container-layout = "tiles";
            default-root-container-orientation = "auto";
            automatically-unhide-macos-hidden-apps = true;

            key-mapping = { preset = "qwerty"; };
            mode.main.binding = {

              # Window management
              cmd-w = "close";
              alt-shift-cmd-ctrl-n = "exec-and-forget open -na 'Neovide'";
              alt-shift-cmd-ctrl-t = "exec-and-forget open -na 'Ghostty'";
              alt-shift-cmd-ctrl-slash = "layout tiles horizontal vertical";
              alt-shift-cmd-ctrl-comma = "layout accordion horizontal vertical";
              alt-shift-cmd-ctrl-m = "fullscreen";

              # Focus movement
              alt-shift-cmd-ctrl-h = "focus left";
              alt-shift-cmd-ctrl-j = "focus down";
              alt-shift-cmd-ctrl--k = "focus up";
              alt-shift-cmd-ctrl--l = "focus right";
              # Focus next monitor
              alt-shift-cmd-ctrl-y = "focus-monitor next --wrap-around";

              # Window movement
              shift-cmd-h = "move left";
              shift-cmd-j = "move down";
              shift-cmd-k = "move up";
              shift-cmd-l = "move right";

              # Window movement to other monitor
              alt-shift-cmd-h = "move-node-to-monitor left";
              alt-shift-cmd-l = "move-node-to-monitor right";

              # Resize windows
              alt-shift-cmd-ctrl-minus = "resize smart -50";
              alt-shift-cmd-ctrl-equal = "resize smart +50";

              # Workspace management
              alt-cmd-1 = "workspace 1";
              alt-cmd-2 = "workspace 2";
              alt-cmd-3 = "workspace 3";
              alt-cmd-4 = "workspace 4";
              alt-cmd-5 = "workspace 5";
              alt-cmd-6 = "workspace 6";
              alt-cmd-7 = "workspace 7";
              alt-cmd-8 = "workspace 8";
              alt-cmd-9 = "workspace 9";

              # Move windows to workspaces
              shift-cmd-1 = "move-node-to-workspace 1";
              shift-cmd-2 = "move-node-to-workspace 2";
              shift-cmd-3 = "move-node-to-workspace 3";
              shift-cmd-4 = "move-node-to-workspace 4";
              shift-cmd-5 = "move-node-to-workspace 5";
              shift-cmd-6 = "move-node-to-workspace 6";
              shift-cmd-7 = "move-node-to-workspace 7";
              shift-cmd-8 = "move-node-to-workspace 8";
              shift-cmd-9 = "move-node-to-workspace 9";

              alt-shift-cmd-ctrl-s = "mode service";
              alt-shift-cmd-ctrl-r = "mode resize";

            };
            mode.resize.binding = {
              # Resize the window
              h = "resize width -50";
              j = "resize height +50";
              k = "resize height -50";
              l = "resize width +50";
              enter = "mode main";
              esc = "mode main";
            };

            mode.service.binding = {
              # Service mode bindings
              esc = [ "reload-config" "mode main" ];
              r = [ "flatten-workspace-tree" "mode main" ];
              f = [ "layout floating tiling" "mode main" ];
              backspace = [ "close-all-windows-but-current" "mode main" ];
              shift-cmd-h = [ "join-with left" "mode main" ];
              shift-cmd-j = [ "join-with down" "mode main" ];
              shift-cmd-k = [ "join-with up" "mode main" ];
              shift-cmd-l = [ "join-with right" "mode main" ];
            };
            # =================================================================
            #
            # Assign apps on particular workspaces
            #
            # Use this command to get IDs of running applications:
            #   aerospace list-apps
            #
            # =================================================================
            # Callbacks
            on-window-detected = [
              {
                "if" = {
                  app-id = "com.apple.Safari";
                  during-aerospace-startup = true;

                };
                check-further-callbacks = false;
                run = "move-node-to-workspace 2";
              }

              {
                "if" = {
                  app-id = "com.apple.mail";
                  during-aerospace-startup = true;
                };
                check-further-callbacks = false;
                run = "move-node-to-workspace 5";
              }
              {
                "if" = {
                  app-id = "com.spotify.client";
                  during-aerospace-startup = true;
                };
                check-further-callbacks = false;
                run = "move-node-to-workspace 6";
              }
              {
                "if" = {
                  app-id = "com.mitchellh.ghostty";
                  during-aerospace-startup = true;
                };
                check-further-callbacks = false;
                run = "move-node-to-workspace 3";
              }
              {
                "if" = {
                  app-id = "im.beeper";
                  during-aerospace-startup = true;
                };
                check-further-callbacks = false;
                run = "move-node-to-workspace 5";
              }
              {
                "if" = {
                  app-id = "com.hnc.Discord";
                  during-aerospace-startup = true;
                };
                check-further-callbacks = false;
                run = "move-node-to-workspace 5";
              }
              {
                "if" = {
                  app-id = "com.neovide.neovide";
                  during-aerospace-startup = true;
                };
                check-further-callbacks = false;
                run = "move-node-to-workspace 1";
              }

            ];

          };
        };
      };

      launchd = {
        user.agents = {
          sketchybar = {
            serviceConfig = {
              StandardOutPath = "/tmp/sketchybar.log";
              StandardErrorPath = "/tmp/sketchybar.log";
            };
          };
        };
      };
    })
    (mkIf cfg.enableJankyborders {
      home-manager.users.${config.people.myself} = {
        xdg.configFile = { "borders/bordersrc".source = ./bordersrc; };
      };
      launchd.user.agents.jankyborders = {
        path = [ pkgs.janky-borders ];
        serviceConfig = {
          ProgramArguments = [ "${pkgs.janky-borders}/bin/borders" ];

          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/borders.log";
          StandardErrorPath = "/tmp/borders.log";
        };
      };
    })
  ];
}
