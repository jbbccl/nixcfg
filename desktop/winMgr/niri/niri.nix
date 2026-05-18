{ config, lib, pkgs, username, helpers, ... }:
let
	inherit (helpers) mkConfigDir mkNiriOutputKdl;
	cfg = config.desktop.winMgr.niri;
	opt = t: d: lib.mkOption { type = t; default = d; };
in {
	options.desktop.winMgr.niri.outputs = lib.mkOption {
		type = lib.types.attrsOf (lib.types.submodule {
			options = {
				mode      = opt (lib.types.nullOr lib.types.str)	null;
				scale     = opt (lib.types.nullOr lib.types.float)  null;
				off       = opt lib.types.bool                      false;
				transform = opt lib.types.str                       "normal";
				position  = opt (lib.types.nullOr (lib.types.submodule {
					options = {
						x = lib.mkOption { type = lib.types.int; };
						y = lib.mkOption { type = lib.types.int; };
					};
				})) null;
			};
		});
		default = {};
	};

	config = lib.mkIf (builtins.elem "niri" config.desktop.winMgr.list) {
		programs.niri.enable = true;

		home-manager.users.${username}.xdg.configFile =
		mkConfigDir "niri" ./config // {
			"niri/output.kdl" = { text = mkNiriOutputKdl cfg.outputs; force = true; };
		};

	environment.systemPackages = with pkgs; [
		xwayland-satellite
		wl-clipboard
	];

	xdg.portal = {
		extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
		config.niri = {
			default = [ "gnome" "gtk" ];
			"org.freedesktop.impl.portal.FileChooser" = "gnome";
			"org.freedesktop.impl.portal.AppChooser" = "gnome";
		};
	};
  };
}
