# this module aims to create a linuxy window-manager-like experience on macos
# for this we utilise the application yabai and skhd
# for an optimal exepreience, yabai needs sip disabled
# Inspired by:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  # to escape $ propertly, config uses that create fsspace
  cfg = config.modules.window-manager.yabai;
  keybindingConfiguration = builtins.readFile ./skhdrc;
in {
  options.modules.window-manager.yabai = {
    enable = mkEnableOption "yabai";
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
        skhd = {
          enable = true;
          skhdConfig = ''
            # movement configurations
            ${keybindingConfiguration}
          '';
        };

        # --- [ SketchyBar ] ---
        sketchybar = {
          extraPackages = [
            pkgs.ripgrep
          ];
          enable = true;
        };

        # --- [ YABAI ] ---
        yabai = {
          enable = true;
          package = pkgs.yabai;
          enableScriptingAddition = true;
          config = {
            window_border = "off";
            window_border_width = 2;
            active_window_border_color = "0xff81a1c1";
            normal_window_border_color = "0xff3b4252";
            focus_follows_mouse = "autoraise";
            mouse_follows_focus = "off";
            mouse_drop_action = "stack";
            window_placement = "second_child";
            window_opacity = "off";
            window_topmost = "off";
            split_ratio = "0.50";
            auto_balance = "on";
            mouse_modifier = "fn";
            mouse_action1 = "move";
            mouse_action2 = "resize";
            layout = "bsp";
            top_padding = 50;
            bottom_padding = 10;
            left_padding = 10;
            right_padding = 10;
            window_gap = 10;
          };
          # https://github.com/koekeishiya/yabai/blob/master/doc/yabai.asciidoc#signal
          # https://felixkratz.github.io/SketchyBar/config/events#triggering-custom-events
          # https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(from-HEAD)
          extraConfig = ''
            yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
            sudo yabai --load-sa

            # rules
            yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
            yabai -m rule --add app='System Preferences' manage=off
            yabai -m rule --add app='mono-stretchly' manage=off

            # window modifications
            yabai -m config window_opacity on
            yabai -m config active_window_opacity 1.0
            yabai -m config normal_window_opacity 0.9

            # sreens
            shift + ctrl + alt - s: screencapture -ic
            shift + ctrl + alt - i: screencapture -i /tmp/$(date +%s).png
            cmd - space: app-launcher
          '';
        };
      };
      launchd = {
        user.agents = {
          # --- [ LOGS ] ---
          skhd.serviceConfig = {
            StandardOutPath = "/tmp/skhd.log";
            StandardErrorPath = "/tmp/skhd.log";
          };
          yabai.serviceConfig = {
            StandardOutPath = "/tmp/yabai.log";
            StandardErrorPath = "/tmp/yabai.log";
          };
          sketchybar = {
            serviceConfig = {
              StandardOutPath = "/tmp/sketchybar.log";
              StandardErrorPath = "/tmp/sketchybar.log";
            };
          };
        };
      };
    })
    (
      mkIf cfg.enableJankyborders {
        home-manager.users.${config.people.myself} = {
          xdg.configFile = {
            "borders/bordersrc".source = ./bordersrc;
          };
        };
        launchd.user.agents.jankyborders = {
          path = [
            pkgs.janky-borders
          ];
          serviceConfig = {
            ProgramArguments = ["${pkgs.janky-borders}/bin/borders"];

            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/borders.log";
            StandardErrorPath = "/tmp/borders.log";
          };
        };
      }
    )
  ];
}
