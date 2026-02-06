{ pkgs, inputs, ... }:
{

environment.systemPackages = with pkgs; [
	# quickshell
	# noctalia-shell
	networkmanagerapplet
	inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
];

services = {
	upower.enable = true;				# 电池
	power-profiles-daemon.enable = true;# 或 tuned
};
}