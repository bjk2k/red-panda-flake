# configuration that is common for all targets and users
{config, ...}: {
  nix = {
    # configureBuildUsers = true;
    settings = {
      trusted-users = ["root" config.my.username];
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
      allowBroken = false;
      allowUnsupportedSystem = true;
    };
    overlays = [
      (import ../packages)
    ];
  };
}
