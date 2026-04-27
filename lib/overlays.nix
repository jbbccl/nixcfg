# lib/overlays.nix — 3-branch nixpkgs overlay factory
# Provides: pkgs.stable (25.11), pkgs.unstable, pkgs.master
# All with allowUnfree = true

{ inputs, system }:

[
  (final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    master = import inputs.nixpkgs-master {
      inherit system;
      config.allowUnfree = true;
    };
  })
]
