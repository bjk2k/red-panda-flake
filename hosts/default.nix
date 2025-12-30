{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake = {
    nixosConfigurations = { };
    darwinConfigurations = {
      lil-red-panda = withSystem "aarch64-darwin" (
        {
          self',
          config,
          inputs',
          system,
          ...
        }:
        inputs.nix-darwin.lib.darwinSystem {
          specialArgs = {
            isDarwin = true;
            isNixOS = false;
            nurNoPkg = import inputs.nur {
              nurpkgs = import inputs.nixpkgs { system = system; };
            };
            inherit (config) packages;
            inherit inputs inputs' system;
          };

          modules = [
            { nixpkgs.hostPlatform = system; }
            ./lil-red-panda.nix
          ];
        }
      );
      lil-dragon = withSystem "x86_64-darwin" (
        {
          self',
          config,
          inputs',
          system,
          ...
        }:
        inputs.nix-darwin.lib.darwinSystem {
          specialArgs = {
            isDarwin = true;
            isNixOS = false;
            nurNoPkg = import inputs.nur {
              nurpkgs = import inputs.nixpkgs { system = system; };
            };
            inherit (config) packages;
            inherit inputs inputs' system;
          };

          modules = [
            { nixpkgs.hostPlatform = system; }
            ./lil-dragon.nix
          ];
        }
      );
    };
  };
  perSystem =
    { system, ... }:
    {
      packages.lil-red-panda = self.darwinConfigurations.lil-red-panda.system;
    };
}
