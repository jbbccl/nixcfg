{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.bar.waybar;

	niri-taskbar = pkgs.callPackage ./niri-taskbar.nix { inherit lib; };

	waybar-bin = if cfg.niriTaskbar then
		pkgs.runCommand "waybar-wrapped"
			{ nativeBuildInputs = [ pkgs.makeWrapper ]; }
			''
			mkdir -p $out/bin
			makeWrapper ${lib.getExe pkgs.waybar} $out/bin/waybar \
				--prefix LD_LIBRARY_PATH : ${niri-taskbar}/lib
			''
	else
		pkgs.waybar;
in
{
	options.desktop.bar.waybar = {
		enable = lib.mkEnableOption "waybar status bar";
		niriTaskbar = lib.mkEnableOption "niri-taskbar cffi plugin";
	};

	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			waybar-bin
			brightnessctl
			networkmanagerapplet
			pwvucontrol
		];

		home-manager.users.${username} = {
			xdg.configFile."waybar/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
		};
	};
}
