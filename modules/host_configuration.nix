{
  lib,
  options,
  ...
}:
with lib; let
  mkOptStr = value:
    mkOption {
      type = with types; uniq str;
      default = value;
    };
in {
  options = {
    my = {
      hostname = mkOptStr "lil-red-panda";
    };
  };
}
