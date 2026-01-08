{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.docker;
in
with lib; {
  options.modules.docker = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Docker with colima backend";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [
        pkgs.colima # Docker runtime for macOS
        pkgs.docker # Docker CLI
        pkgs.docker-compose # Compose for multi-container apps
        pkgs.docker-credential-helpers # Credential management
        pkgs.dive # Explore docker image layers
      ];

      # Set up docker socket path for colima compatibility
      shellInit = ''
        export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
      '';
    };

    # Note: To start colima, run:
    # colima start --cpu 4 --memory 8 --disk 60
    #
    # For Kubernetes support with colima:
    # colima start --kubernetes
  };
}
