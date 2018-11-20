{ compiler }:
let
  haskellOverlay = (self: super: {
    haskellPackages = super.haskell.packages."${compiler}".override {
      overrides = (new: old: {
        scotty-bytestring = old.callPackage ../pkgs/scotty-bytestring {};
      });
    };
  });

  nonHaskellOverlay = (self: super: {
  });
in
  [nonHaskellOverlay haskellOverlay]
