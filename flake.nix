{
  description = "Nix toolchain in use by bjk2k. Full of cute red-pandas and tumbleweeds.";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      # Manages configs links things into your home directory
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      # Controls system level software and settings including fonts
      url = "github:Lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tricked out nvim
    pwnvim.url = "github:bjk2k/pwnvim-with-red-pandas";
    neve.url = "github:bjk2k/neve";

    # custom icons
    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";
    nur.url = "github:nix-community/NUR";

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
      ];
      imports = [
        ./hosts
        ./modules
      ];
      perSystem = {
        config,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      };
    };
}
