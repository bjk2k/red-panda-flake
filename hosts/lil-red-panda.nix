{
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

  my.hostname = "lil-red-panda";

  people = {
    myself = "ben-jasperkettlitz";
    users = {
      ben-jasperkettlitz = {
        name = "Ben-Jasper Kettlitz";
        email = "b-jk@gmx.net";
        sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLblwwOIK1jkxONqdOMrrye8a0lZLXsZ4h8akeQ1vvn b-jk@gmx.net";
      };
    };
  };

  home-manager.users.${config.people.myself} = {lib, ...}: {
    programs.git = {
      extraConfig = {
        github.user = "bjk2k";
      };
    };
    home.activation.name = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p personal $VERBOSE_ARG
      run mkdir -p projects $VERBOSE_ARG
      run mkdir -p work $VERBOSE_ARG
    '';
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
      brews = [
        "nowplaying-cli"
      ];
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
