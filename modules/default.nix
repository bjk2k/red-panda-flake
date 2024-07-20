{...}: {
  flake.nixosModules = {
    common.imports = [
      ./terminal
      ./tmux
      ./home.nix
      ./common.nix
      ./host_configuration.nix
    ];
    darwin.imports = [
      ./window-manager/yabai.nix
      ./brew.nix
      ./mac.nix
    ];
  };
}
