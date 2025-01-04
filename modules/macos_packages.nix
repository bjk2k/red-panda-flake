{ pkgs, ... }:
with pkgs;
let
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full tocbibind xcharter tuda-ci;
  };
in [
  # alerter
  # -- [ Latex ] --
  tex

  tailscale
  zed-editor
]
