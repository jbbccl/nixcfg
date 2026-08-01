# lib/overlays.nix — stable-branch overlay
# Provides: pkgs.stable (26.05) alongside the default (unstable) nixpkgs.
# The default nixpkgs already follows nixos-unstable, so no unstable/master
# branches are needed here.
{
  inputs,
  system,
}: [
  (final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  })
]
