{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.winMgr.niri;
	mkKdlBlocks = name: mkLines: attrs:
		builtins.concatStringsSep "\n" (
			lib.mapAttrsToList (key: val:
				let
					body = builtins.concatStringsSep "\n" (mkLines key val);
				in
				if body == "" then "" else "${name} \"${key}\" {\n${body}\n}\n"
			) attrs
		);
	mkNiriOutputKdl = mkKdlBlocks "output" (_: out:
		     lib.optional out.off                     "    off"
		  ++ lib.optional (out.mode != null)          "    mode \"${out.mode}\""
		  ++ lib.optional (out.scale != null)         "    scale ${builtins.toString out.scale}"
		  ++ lib.optional (out.transform != "normal") "    transform \"${out.transform}\""
		  ++ lib.optional (out.position != null)      "    position x=${builtins.toString out.position.x} y=${builtins.toString out.position.y}"
	);
	opt = t: d: lib.mkOption { type = t; default = d; };
in {
	options.desktop.winMgr.niri.enable = lib.mkEnableOption "niri window manager";
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

	config = lib.mkIf cfg.enable {
		programs.niri.enable = true;

		home-manager.users.${username}.xdg.configFile =
			{
				"niri/" = {
					force = true;
					recursive = true;
					source = ./config;
				};
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

    programs.uwsm = {
		enable = true;
		waylandCompositors = {
			niri = {
				prettyName = "Niri";
				comment = "Niri compositor managed by UWSM";
				binPath = "${lib.getExe pkgs.niri}";
				extraArgs = [ "--session" ];
			};
		};
	};

  };
}
