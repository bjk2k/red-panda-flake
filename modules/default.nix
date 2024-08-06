{...}: {
  flake.nixosModules = {
    common.imports = [
      ./terminal
      ./tmux
      ./common.nix
      ./users
      ./host_configuration.nix
    ];
    darwin.imports = [
      ./window-manager/yabai.nix
      ./brew.nix
      ./mac.nix
      ./podman
    ];
  };
}
