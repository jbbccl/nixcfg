{ config, lib, pkgs, username, hostName, ... }:
# special-opt.nix — host-specific overrides (desktop)
#
# ═══════════════════════════════════════════════════════════════
# Priority system (lower number = higher priority):
#   50   lib.mkForce       — override everything
#   100  bare assignment   — standard override
#   1000 lib.mkDefault     — default, easily overridable
#
# Common config uses lib.mkDefault for host-variable values.
# Override them here with bare assignments.
#
# Examples (uncomment to activate):
#   desktop.windowManager = [ "hypr" ];
#   boot.kernelPackages = pkgs.linuxPackages_latest;
# ═══════════════════════════════════════════════════════════════
{
	# Desktop-specific overrides go here
}
