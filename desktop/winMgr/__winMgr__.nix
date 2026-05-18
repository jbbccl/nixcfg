{ config, lib, pkgs, username, ... }: {
	imports = [
		./niri/niri.nix
		./hypr/hypr.nix
		./labwc/labwc.nix
		./mangowc/mangowc.nix
	];

	config = lib.mkIf (lib.length (config.desktop.windowManager or []) > 0) {
		environment.sessionVariables.NIXOS_OZONE_WL = "1";

		environment.systemPackages = with pkgs; [
			xauth
			polkit_gnome
			seahorse
		];

		# ── policy ─────────────────────────────────────────────────────
		security.polkit.enable = true;
		services.gnome.gnome-keyring.enable = true;
		systemd.user.services.polkit-gnome-authentication-agent-1 = {
			description = "polkit-gnome-authentication-agent-1";
			wantedBy = [ "graphical-session.target" ];
			wants = [ "graphical-session.target" ];
			after = [ "graphical-session.target" ];
			serviceConfig = {
				Type = "simple";
				ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
				Restart = "on-failure";
				RestartSec = 1;
				TimeoutStopSec = 10;
			};
		};

		# ── portal ──────────────────────────────────────────────────────
		xdg = {
			mime.enable = true;
			menus.enable = true;
		};
		xdg.portal = {
			enable = true;
			xdgOpenUsePortal = true;
			extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
			config = {
				# common.default = [ "gtk" "wlr"];
				# common."org.freedesktop.portal.FileChooser" = [ "kde" "gtk" ];
			};
		};
	};
}
