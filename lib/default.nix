# lib/default.nix — public API for lib/
#
# Usage in flake.nix:
#   lib = import ./lib { inherit inputs system; };
#   # then: pkgs = import nixpkgs { inherit system; overlays = lib.nixpkgsOverlays; }
#   #       lib.validators.nonEmptyListOf ...

{ inputs, system, lib ? inputs.nixpkgs.lib }:

{
  nixpkgsOverlays = import ./overlays.nix { inherit inputs system; };
  validators = import ./validators.nix { inherit lib; };
}
