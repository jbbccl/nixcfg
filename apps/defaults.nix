{ lib, ... }: {
	config = {
		apps.services = lib.mkDefault true;
		apps.gui = lib.mkDefault true;
		apps.cli = lib.mkDefault true;
	};
}
