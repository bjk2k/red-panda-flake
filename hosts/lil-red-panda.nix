{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.self.nixosModules.common
    inputs.self.nixosModules.darwin
  ];

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  my = {
    hostname = "lil-red-panda";
    homeDirectory = "/Users/${config.people.myself}";
  };

  home-manager.users.${config.people.myself}.programs = {
    git = {
      extraConfig = {
        github.user = "bjk2k";
      };
    };
  };

  modules = {
    brew = {
      enable = true;
      casks = [
        "raycast"
        "beeper"
        "nvidia-geforce-now"
        "steam"
        "motion"
      ];
      brews = [];
    };
    tmux = {
      enable = true;
    };
    terminal = {
      enable = true;
    };
    window-manager = {
      yabai.enable = true;
      yabai.enableJankyborders = true;
    };
  };
}
