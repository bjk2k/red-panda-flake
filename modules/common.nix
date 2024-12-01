# configuration that is common for all targets and users
{
  config,
  inputs',
  ...
}: {
  nix = {
    # configureBuildUsers = true;
    settings = {
      trusted-users = ["root" config.people.myself];
    };
    # Avoid unwanted garbage collection when using nix-direnv
    extraOptions = ''
      gc-keep-derivations = true
      gc-keep-outputs = true
      min-free = 17179870000
      max-free = 17179870000
      log-lines = 128

      experimental-features = nix-command flakes auto-allocate-uids
      keep-outputs          = true
      keep-derivations      = true
      fallback              = true
      extra-trusted-users   = ${config.people.myself}
    '';
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowUnsupportedSystem = true;
    };
    overlays = [
      (_final: _prev: {
        stable = inputs'.nixpkgs-stable.legacyPackages;
      })
      
      # apply zig-overlay from inputs
      (_final: _prev: {
        zig = inputs'.zig.overlay;
      })

      (import ../packages)
    ];
  };
}
