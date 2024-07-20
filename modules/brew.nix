{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.brew;
in {
  options.modules.brew = {
    enable = mkEnableOption "brew";
    brews = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    casks = mkOption {
      type = types.listOf types.str;
      default = ["firefox"];
    };
    masApps = mkOption {
      type = with types; attrsOf ints.positive;
      default = {};
    };
    extraConfig = mkOption {
      type = types.lines;
      default = ''
        cask "firefox", args: { language: "en-CA" }
      '';
    };
  };

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
      };
      global = {
        brewfile = true;
        autoUpdate = true;
        lockfiles = true;
      };
      # homebrew.taps = cfg.taps;
      inherit (cfg) brews;
      inherit (cfg) casks;
      inherit (cfg) masApps;
    };
  };
}
