_final: prev: {
  janky-borders = prev.callPackage ./JankyBorders.nix {
    inherit (_final.darwin.apple_sdk_11_0.frameworks) AppKit CoreVideo Carbon SkyLight;
  };
  sf-symbols = prev.callPackage ./sf_symbols.nix {};
  sbarlua = prev.callPackage ./sketchybar-lua.nix {};
  vfkit = prev.callPackage ./vfkit.nix {};
}
