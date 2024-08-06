{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.podman;

  # Work around https://github.com/containers/podman/issues/17026
  # ndows?by downgrading to qemu-8.1.3.
  inherit
    (import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "4db6d0ab3a62ea7149386a40eb23d1bd4f508e6e";
      sha256 = "sha256-kyw7744auSe+BdkLwFGyGbOHqxdE3p2hO6cw7KRLflw=";
    }) {inherit (pkgs) system;})
    qemu
    ;
in
  with lib; {
    options.modules.podman = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };

    config = mkIf cfg.enable {
      environment = {
        systemPackages = [
          pkgs.podman
          qemu
          pkgs.xz

          pkgs.dive # look into docker image layers
          pkgs.podman-tui # status of containers in the terminal
          pkgs.docker-compose # start group of containers for dev
        ];

        # https://github.com/containers/podman/issues/17026
        pathsToLink = ["/share/qemu"];

        # https://github.com/LnL7/nix-darwin/issues/432#issuecomment-1024951660
        etc."containers/containers.conf.d/99-gvproxy-path.conf".text = ''
          [engine]
          helper_binaries_dir = ["${pkgs.gvproxy}/bin"]
        '';
      };
    };
  }
