{ config, lib, pkgs, ... }:
let
	base = config.desktop.base;
in
{
	config = {
		stylix = {
			enable = true;
			polarity = "dark";
			base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

			fonts = {
				serif = { package = pkgs.maple-mono.NF-CN; name = "Maple Mono NF CN"; };
				sansSerif = { package = pkgs.maple-mono.NF-CN; name = "Maple Mono NF CN"; };
				monospace = { package = pkgs.maple-mono.NF-CN; name = "Maple Mono NF CN"; };
				emoji = { package = pkgs.noto-fonts-color-emoji; name = "Noto Color Emoji"; };
				sizes = { applications = base.fontSize; desktop = base.fontSize; terminal = base.fontSize; };
			};

			icons = {
				enable = true;
				package = base.iconThemePackage;
				dark = base.iconThemeName;
			};

			targets = {
				gtk.enable = true;
				qt.enable = true;
				qt.platform = "qtct";
			};
		};
	};
}
