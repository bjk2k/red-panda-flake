{
  description = "Nix toolchain in use by bjk2k. Full of cute red-pandas and tumbleweeds.";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      # Manages configs links things into your home directory
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      # Controls system level software and settings including fonts
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tricked out nvim
    pwnvim.url = "github:bjk2k/pwnvim-with-red-pandas";
    neve.url = "github:bjk2k/neve";

    # custom icons
    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: let
    mkSystem = import ./lib/mksystem.nix {
      inherit nixpkgs inputs;
    };
  in {
    nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" rec {
      system = "aarch64-linux";
      user = "ben-jasperkettiltz";
    };

    darwinConfigurations.macbook-pro-m1 = mkSystem "lil-red-panda" {
      system = "aarch64-darwin";
      user = "ben-jasperkettiltz";
      darwin = true;
    };
  };
}
