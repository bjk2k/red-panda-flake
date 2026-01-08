{ ... }: {
  flake.nixosModules = {
    common.imports =
      [ ./terminal ./tmux ./common.nix ./users ./host_configuration.nix ];
  };

  flake.darwinModules = {
    common.imports =
      [ ./terminal ./tmux ./common.nix ./users ./host_configuration.nix ];
    darwin.imports =
      [ ./window-manager/aerospace.nix ./brew.nix ./mac.nix ./podman ./docker ];
  };
}
