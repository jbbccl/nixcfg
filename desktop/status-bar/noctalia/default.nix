{ config, lib, pkgs, inputs, ... }: {
  config = lib.mkIf (builtins.elem "noctalia" config.desktop.bar) {
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
