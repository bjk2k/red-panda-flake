{
  pkgs,
  inputs,
  ...
}: {
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  programs.zsh.enable = true;

  users.users.ben-jasperkettlitz = {
    isNormalUser = true;
    home = "/home/ben-jasperkettlitz";
    extraGroups = ["docker" "wheel"];
    shell = pkgs.zsh;
    hashedPassword = "02ef052036b6e1997f4dc9bdfd862a49ce5fb6387146bb50333b0bece5564c3678e1ee1a9392d8f03b9a1bfe0bdd32865bfa997ba263b1bff6f90cd8a07043e1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLblwwOIK1jkxONqdOMrrye8a0lZLXsZ4h8akeQ1vvn b-jk@gmx.net"
    ];
  };
}
