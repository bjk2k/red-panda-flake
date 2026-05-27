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
            {
              nixpkgs.hostPlatform = system;
              # pipx 1.8.0 tests run as installCheckPhase (doInstallCheck=1),
              # NOT checkPhase -- so doCheck=false has no effect. Disable
              # doInstallCheck instead. Remove once nixpkgs fixes upstream tests.
              nixpkgs.overlays = [
                (final: prev: {
                  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
                    (pyFinal: pyPrev: {
                      pipx = pyPrev.pipx.overrideAttrs (_: {
                        doInstallCheck = false;
                      });
                    })
                  ];
                })
              ];
            }
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
            {
              nixpkgs.hostPlatform = system;
              # pipx 1.8.0 tests run as installCheckPhase (doInstallCheck=1),
              # NOT checkPhase -- so doCheck=false has no effect. Disable
              # doInstallCheck instead. Remove once nixpkgs fixes upstream tests.
              nixpkgs.overlays = [
                (final: prev: {
                  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
                    (pyFinal: pyPrev: {
                      pipx = pyPrev.pipx.overrideAttrs (_: {
                        doInstallCheck = false;
                      });
                    })
                  ];
                })
              ];
            }
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
