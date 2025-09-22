{
  description =
    "Nix toolchain in use by bjk2k. Full of cute red-pandas and tumbleweeds.";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    agenix.url = "github:ryantm/agenix";

    home-manager = {
      # Manages configs links things into your home directory
      # url = "github:nix-community/home-manager/951f0b30c535a46817aa5ef4c66ddc4445f3e324";
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      # Controls system level software and settings including fonts
      # url = "github:Lnl7/nix-darwin/nix-darwin-24.11";
      url = "github:Lnl7/nix-darwin/master";
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

    zig.url = "github:mitchellh/zig-overlay";

    ghostty = { url = "github:ghostty-org/ghostty"; };
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" ];
      imports = [ ./hosts ./modules ];
      perSystem = { config, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowBroken = true;
          };
        };
      };
    };
}
