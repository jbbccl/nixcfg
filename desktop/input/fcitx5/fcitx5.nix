{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.input.fcitx5;
	rime-ice-tag = "2026.03.26";
	rime-ice = pkgs.stdenvNoCC.mkDerivation {
		pname = "rime-ice";
		version = rime-ice-tag;
		src = pkgs.fetchFromGitHub {
			owner = "iDvel";
			repo = "rime-ice";
			rev = rime-ice-tag;
			hash = "sha256-hRtA1cYAQm7M+dPSThedqKogr8YMkP9WQFEZw5pdCbU=";
		};
		installPhase = ''
			mkdir -p $out/share/rime-data
			rm -rf ./others
			rm -f README.md LICENSE
			rm -rf ./.github
			rm default.yaml custom_phrase.txt
			cp -r ./* $out/share/rime-data
		'';
	};
in
{
	options.desktop.input.fcitx5.enable = lib.mkEnableOption "fcitx5 input method";

	config = lib.mkIf cfg.enable {
		home-manager.users.${username} = {
			xdg.configFile."fcitx5/" = {
				force = true;
				recursive = true;
				source = ./config;
			};

			xdg.dataFile = {
				"fcitx5/rime/" = {
					source = "${rime-ice}/share/rime-data";
					force = true;
					recursive = true;
					onChange = ''
						mkdir -p ~/.local/share/fcitx5/rime
						chmod -R u+w ~/.local/share/fcitx5/rime
						rm -f ~/.local/share/fcitx5/rime/*.bin
					'';
				};
				"fcitx5/" = {
					force = true;
					recursive = true;
					source = ./share;
				};
			};
		};

		i18n = {
			inputMethod = {
				type = "fcitx5";
				enable = true;
				fcitx5 = {
					waylandFrontend = true;
					addons = with pkgs; [
						fcitx5-rime
						librime-lua
						rime-ice
					];
				};
			};
		};
	};
}
