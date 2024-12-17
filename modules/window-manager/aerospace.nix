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
        home = { packages = [ pkgs.aerospace ]; };
        xdg.configFile."sketchybar".source = ./sketchybar;
        xdg.configFile."aerospace/aerospace.toml".source = ./aerospace.toml;
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
