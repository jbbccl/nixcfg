{ config, lib, pkgs, username, ... }:
let
    cfg = config.desktop.wallpaper;
	plasma-walls = pkgs.fetchgit {
		url = "https://github.com/KDE/plasma-workspace-wallpapers.git";
		rev = "d895680ddd3fc379a11d72be80e2bb06984291da";
		sparseCheckout = [ "ScarletTree" "FallenLeaf" "OneStandsOut" "Autumn" "Altai" "BytheWater" ];
		hash = "sha256-3pXc72LFGRaKkpIi/pJ/ngS9ys7jFMy+uOOfkTX8Pds=";
	};
in
{
	imports = [
		./awww/awww.nix
		./waypaper/waypaper.nix
	];

    options.desktop.wallpaper.enable = lib.mkEnableOption "wallpaper";

	config = lib.mkIf cfg.enable {
		desktop.wallpaper = lib.mkDefault {
			awww.enable = true;
			waypaper.enable = true;
		};

		home-manager.users.${username} = {
			home.file.".local/share/wallpapers/plasma" = {
				source = plasma-walls;
				force = true;
				recursive = true;
			};
			home.file.".local/share/wallpapers/collect" = {
				source = ./collect;
				force = true;
				recursive = true;
			};
		};
	};
}
