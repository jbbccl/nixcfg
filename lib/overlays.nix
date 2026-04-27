# lib/overlays.nix — 3-branch nixpkgs overlay factory
# Provides: pkgs.stable (25.11), pkgs.unstable, pkgs.master
# All with allowUnfree = true
#
# Performance note: this eagerly imports 3 full nixpkgs instances.
# If eval time becomes an issue (many packages, slow hardware),
# switch to lazy mode below — it uses a single nixpkgs import + extend
# for each branch, sharing the base package set between all three.

{ inputs, system }:

let
	# ── Eager mode (current, simple) ──
	eager = [
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
	];

  # ── Lazy mode (future, single import + extend) ──
  # Downside: pkgs.stable.X vs pkgs.X may be the same derivation
  # if the package hasn't changed between branches. This is usually
  # desired (fewer rebuilds) but can mask version differences.
  #
  # lazy = [
  #   (final: prev: {
  #     stable = prev.extend (import "${inputs.nixpkgs-stable}/pkgs/top-level/impure.nix" {
  #       inherit system;
  #       config.allowUnfree = true;
  #     }).overlays or (_: _: {});
  #   })
  # ];
in
  eager
