{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.terminal;
in {
  # error: infinite recursion encountered
  # imports = [ nix-colors.homeManagerModule ];
  options.modules.terminal = {
    enable = mkEnableOption "terminal";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.people.myself} = {
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
