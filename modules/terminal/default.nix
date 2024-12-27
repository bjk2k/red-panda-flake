{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.terminal;
in {
  # error: infinite recursion encountered
  # imports = [ nix-colors.homeManagerModule ];
  options.modules.terminal = { enable = mkEnableOption "terminal"; };

  config = mkIf cfg.enable {
    home-manager.users.${config.people.myself} = {
      xdg.configFile."ghostty/config".source = ./ghostty.conf;
      xdg.configFile."ghostty/themes/kanagawa-dragon".source =
        ./kanagawa-dragon.theme;
      programs = {
        starship = {
          enable = true;
          enableZshIntegration = true;
          settings = pkgs.lib.importTOML ./starship.toml;
        };
      };
    };
  };
}
