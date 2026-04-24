{ config, lib, pkgs, inputs, ... }: {
  config = lib.mkIf (config.desktop.bar == "noctalia") {
	environment.systemPackages = with pkgs; [
		networkmanagerapplet
		inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
	];

	services = {
		upower.enable = true;
		power-profiles-daemon.enable = true;
	};
  };
}
