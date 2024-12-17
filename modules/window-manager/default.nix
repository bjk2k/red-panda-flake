{ config, lib, pkgs, ... }: {
  config = lib.mkMerge
    [ (lib.mkIf pkgs.stdenv.isDarwin { imports = [ ./aerospace.nix ]; }) ];
}
