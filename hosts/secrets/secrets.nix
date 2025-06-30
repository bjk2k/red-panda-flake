let
  yubi_main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDBRiyeVv+opI5Sk28uM/HXXhICVMPYTGBziUZ0BtLWR bjk2k-main";
in
{
  "anthropic_key.age".publicKeys = [ yubi_main ];
}
