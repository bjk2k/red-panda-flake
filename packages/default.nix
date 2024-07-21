_final: prev: {
  janky-borders = prev.callPackage ./JankyBorders.nix {
    inherit (_final.darwin.apple_sdk_11_0.frameworks) AppKit CoreVideo Carbon SkyLight;
  };
}
