{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with pkgs.stdenv;
with lib; let
  currentUser = config.people.myself;
  currentSystemName = config.my.hostname;
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

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

  # We install Nix using a separate installer so we don't want nix-darwin
  # to manage it for us. This tells nix-darwin to just use whatever is running.
  nix.useDaemon = true;
  # fix see https://github.com/NixOS/nix/issues/6499
  services.nix-daemon.enable = true;

  # needed for e.g. discord and vscode
  nixpkgs.config.allowUnfree = true;

  # Keep in async with vm-shared.nix. (todo: pull this out into a file)
  nix = {
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };

    # We need to enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  programs = {
    zsh = {
      # zsh is the default shell on Mac and we want to make sure that we're
      # configuring the rc correctly with nix-darwin paths.
      enable = true;
      shellInit = ''
        # Nix
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
        # End Nix
      '';
    };
  };

  users.users.${currentUser} = {
    shell = pgs.zsh;
    home = "/Users/${currentUser}";
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = false;
    users.${currentUser} = import ./home.nix {inherit inputs pkgs lib config;};
  };

  environment = {
    shells = with pkgs; [bashInteractive zsh];
    systemPackages = with pkgs; [
      cachix
    ];
  };

  networking = {
    hostName = currentSystemName;
    computerName = currentSystemName;
  };

  system = {
    defaults.smb.NetBIOSName = currentSystemName;

    defaults = {
      finder.AppleShowAllExtensions = true;
      finder._FXShowPosixPathInTitle = true;
      trackpad = {
        Clicking = true; # enable tap to click
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = true; # enable three finger drag
      };
      dock = {
        autohide = true; # Autohide the dock
        persistent-apps = [
          "/Applications/Safari.app"
          "/System/Applications/Mail.app"
          "/Applications/Beeper.app"
          "/System/Applications/Messages.app"
          "${pkgs.kitty}/Applications/Kitty.app/"
        ];
        persistent-others = [
          "/Users/${currentUser}/"
          "/Users/${currentUser}/personal"
          "/Users/${currentUser}/projects"
          "/Users/${currentUser}/work"
          "/Users/${currentUser}/Downloads"
        ];
        show-recents = false; # Do not show recent applications
      };
      NSGlobalDomain = {
        _HIHideMenuBar = true;
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 14;
        KeyRepeat = 1;
      };
    };

    # --- [ KEYBOARD ] ---
    keyboard = {
      enableKeyMapping = true; # enable key mapping so that we can use `option` as `control`

      remapCapsLockToEscape = true; # remap caps lock to escape, useful for vim users

      # swap left command and left alt
      # so it matches common keyboard layout: `ctrl | command | alt`
      #
      # disabled, caused only problems!
      swapLeftCommandAndLeftAlt = false;
    };
    # backwards compat; don't change
    stateVersion = 4;
  };
}
