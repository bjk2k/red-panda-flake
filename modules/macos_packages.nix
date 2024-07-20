{pkgs, ...}:
with pkgs; let
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full tocbibind;
  };
in [
  # alerter
  # -- [ Latex ] --
  tex
  tailscale
]
