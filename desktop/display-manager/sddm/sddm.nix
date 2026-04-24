{ config, lib, pkgs, ... }: {
  config = lib.mkIf (config.desktop.displayManager == "sddm") {
	services.displayManager.sddm = {
		enable = true;
		wayland.enable = true;
		theme = "catppuccin-macchiato-mauve";
	};

	environment.systemPackages = [
		(pkgs.catppuccin-sddm.override {
			flavor = "macchiato";
			font  = "Maple Mono NF CN";
			fontSize = "12";
			loginBackground = false;
		})
	];
  };
}
