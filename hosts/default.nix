{
  self,
  inputs,
  withSystem,
  ...
}: {
  flake = {
    darwinConfigurations = {
      lil-red-panda = withSystem "aarch64-darwin" ({
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
              nurpkgs = import inputs.nixpkgs {system = system;};
            };
            packages = config.packages;
            inherit inputs inputs';
          };

          modules = [
            {
              nixpkgs.hostPlatform = system;
            }
            ./lil-red-panda.nix
          ];
        });
    };
  };
  perSystem = {system, ...}: {
    packages.lil-red-panda = self.darwinConfigurations.lil-red-panda.system;
  };
}
