{
  inputs,
  pkgs,
  ...
}: {
  # --- [ FONTS ] ---

  # fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "CodeNewRoman"
        "FantasqueSansMono"
        "Iosevka"
        "ShareTechMono"
        "Hermit"
        "JetBrainsMono"
        "FiraCode"
        "FiraMono"
        "Hack"
        "Hasklig"
        "Ubuntu"
        "UbuntuMono"
      ];
    })
  ];

  # --- [ HOMEBREW ] ---
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    onActivation = {
      cleanup = "zap";
    };
    masApps = {};
    casks = ["raycast" "amethyst" "beeper" "nvidia-geforce-now" "steam" "motion"];
    taps = [];
    brews = [];
  };

  # casks = [
  #   "1password"
  #   "cleanshot"
  #   "discord"
  #   "google-chrome"
  #   "hammerspoon"
  #   "imageoptim"
  #   "istat-menus"
  #   "monodraw"
  #   "raycast"
  #   "rectangle"
  #   "screenflow"
  #   "slack"
  #   "spotify"
  # ];

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.ben-jasperkettlitz = {
    shell = pkgs.fish;
    home = "/Users/ben-jasperkettlitz/";
  };
}
