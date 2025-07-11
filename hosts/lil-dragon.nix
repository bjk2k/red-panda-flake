{ inputs, config, ... }: {
  imports = [ inputs.self.nixosModules.common inputs.self.nixosModules.darwin ];

  environment.systemPath = [ "/opt/homebrew/bin" "/opt/homebrew/sbin" ];

  my.hostname = "lil-dragon";

  people = {
    myself = "ben-jasperkettlitz";
    users = {
      ben-jasperkettlitz = {
        name = "Ben-Jasper Kettlitz";
        email = "b-jk@gmx.net";
        sshKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLblwwOIK1jkxONqdOMrrye8a0lZLXsZ4h8akeQ1vvn b-jk@gmx.net";
      };
    };
  };

  age = {
    identityPaths = [ "/Users/ben-jasperkettlitz/.ssh/id_ed25519_bjk2k" ];
    secrets = {
      anthropic_key = {
        file = ./secrets/anthropic_key.age;
        mode = "0400";
        owner = config.people.myself;
      };
    };
  };
  home-manager.users.${config.people.myself} = { lib, ... }: {
    programs.git = { extraConfig = { github.user = "bjk2k"; }; };
    home.activation.setupProjectDirectories =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p personal $VERBOSE_ARG
        run mkdir -p personal/orgfiles $VERBOSE_ARG
        run mkdir -p projects $VERBOSE_ARG
        run mkdir -p work $VERBOSE_ARG
      '';

    # Inject secret into settings.json at activation time
    home.activation.templateZedConfigAPIKey =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        secret=$(cat ${config.age.secrets.anthropic_key.path})
        echo $secret > $HOME/.anthropic_key
      '';
  };
  system.primaryUser = config.people.myself;

  modules = {
    podman.enable = true;
    brew = {
      enable = true;
      casks = [ "raycast" "beeper" "motion" "github" "ghostty" "keycastr" ];
      brews = [ "nowplaying-cli" "libfido2" ];
    };
    tmux = { enable = true; };
    terminal = { enable = true; };
    window-manager = {
      aerospace.enable = true;
      aerospace.enableJankyborders = true;
    };
  };
}
