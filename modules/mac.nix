{ inputs, config, lib, pkgs, ... }:
with pkgs.stdenv;
with lib;
let
  currentUser = config.people.myself;
  currentSystemName = config.my.hostname;
in {
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  # --- [ FONTS ] ---

  # fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];
  fonts.packages = with pkgs; [
    nerd-fonts._3270
    nerd-fonts.agave
    nerd-fonts.anonymice
    nerd-fonts.arimo
    nerd-fonts.aurulent-sans-mono
    nerd-fonts.bigblue-terminal
    nerd-fonts.bitstream-vera-sans-mono
    nerd-fonts.blex-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.code-new-roman
    nerd-fonts.comic-shanns-mono
    nerd-fonts.commit-mono
    nerd-fonts.cousine
    nerd-fonts.d2coding
    nerd-fonts.daddy-time-mono
    nerd-fonts.departure-mono
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.envy-code-r
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.geist-mono
    nerd-fonts.go-mono
    nerd-fonts.gohufont
    nerd-fonts.hack
    nerd-fonts.hasklug
    nerd-fonts.heavy-data
    nerd-fonts.hurmit
    nerd-fonts.im-writing
    nerd-fonts.inconsolata
    nerd-fonts.inconsolata-go
    nerd-fonts.inconsolata-lgc
    nerd-fonts.intone-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab
    nerd-fonts.jetbrains-mono
    nerd-fonts.lekton
    nerd-fonts.liberation
    nerd-fonts.lilex
    nerd-fonts.martian-mono
    nerd-fonts.meslo-lg
    nerd-fonts.monaspace
    nerd-fonts.monofur
    nerd-fonts.monoid
    nerd-fonts.mononoki
    nerd-fonts.noto
    nerd-fonts.open-dyslexic
    nerd-fonts.overpass
    nerd-fonts.profont
    nerd-fonts.proggy-clean-tt
    nerd-fonts.recursive-mono
    nerd-fonts.roboto-mono
    nerd-fonts.shure-tech-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.space-mono
    nerd-fonts.symbols-only
    nerd-fonts.terminess-ttf
    nerd-fonts.tinos
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
    nerd-fonts.victor-mono
    nerd-fonts.zed-mono
  ];

  # We install Nix using a separate installer so we don't want nix-darwin
  # to manage it for us. This tells nix-darwin to just use whatever is running.

  # needed for e.g. discord and vscode
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

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
    shell = pkgs.zsh;
    home = "/Users/${currentUser}";
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = false;
    users.${currentUser} =
      import ./home.nix { inherit inputs pkgs lib config; };
  };

  environment = {
    shells = with pkgs; [ bashInteractive zsh ];
    systemPackages = with pkgs; [ cachix ];
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
          # "${pkgs.kitty}/Applications/Kitty.app/"
          "/Applications/Ghostty.app"
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
      enableKeyMapping =
        true; # enable key mapping so that we can use `option` as `control`

      remapCapsLockToEscape =
        true; # remap caps lock to escape, useful for vim users

      # swap left command and left alt
      # so it matches common keyboard layout: `ctrl | command | alt`
      #
      # disabled, caused only problems!
      swapLeftCommandAndLeftAlt = false;
    };
    # backwards compat; don't change
    stateVersion = 5;
  };
}
