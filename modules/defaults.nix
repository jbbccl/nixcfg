{ lib, ... }: {
	# Enable all module groups by default.
	# Set to false in special-opt.nix to disable a group.
	config = {
		modules.services = lib.mkDefault true;
		modules.development = lib.mkDefault true;
		modules.shells = lib.mkDefault true;
		modules.virtualization = lib.mkDefault true;
		modules.utilities = lib.mkDefault true;
	};
}
