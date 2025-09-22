_final: prev: {
  janky-borders = prev.callPackage ./JankyBorders.nix {};
  sf-symbols = prev.callPackage ./sf_symbols.nix {};
  sbarlua = prev.callPackage ./sketchybar-lua.nix {};
  vfkit = prev.callPackage ./vfkit.nix {};
}
