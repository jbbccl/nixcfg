# lib/default.nix — public API for lib/
#
# Usage in flake.nix:
#   lib = import ./lib { inherit inputs system; };
#   # then: pkgs = import nixpkgs { inherit system; overlays = lib.nixpkgsOverlays; }

{ inputs, system }:

{
  nixpkgsOverlays = import ./overlays.nix { inherit inputs system; };
}
