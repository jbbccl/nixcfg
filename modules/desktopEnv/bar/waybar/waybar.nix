{ options }: 
{ pkgs, username, ... }:
let
niri-taskbar = pkgs.rustPlatform.buildRustPackage {
	pname = "niri-taskbar";
	version = "2025.10.12";

	src = builtins.fetchGit {
	url = "https://github.com/LawnGnome/niri-taskbar.git";
	ref = "main";
	rev = "c530349fae638141ec58a9d4db0816d950a9295a"; 
	};
	cargoHash = "sha256-WRc1+ZVhiIfmLHaczAPq21XudI08CgVhlIhVcf0rmSw=";
	nativeBuildInputs = with pkgs; [
		pkg-config
		pango
		gtk3
	];
	buildInputs = with pkgs; [
		pkg-config
		pango
		gtk3
    ];
	installPhase = ''
	mkdir -p $out/lib
	cargo build --release
	cp -r ./target/release/libniri_taskbar.so $out/libniri_taskbar.so
	'';
};
in
{
# programs.waybar.enable = true;
	environment.systemPackages = with pkgs; [
		waybar
		brightnessctl
		networkmanagerapplet
		pwvucontrol

		fuzzel
		# wofi


		swaylock
		swayidle

		waypaper
		swww

	];

	home-manager.users.${username} = {
		services.mako.enable = true;
		xdg.configFile = {
			"waybar/config.jsonc" = {
				force = true;
				source = (
					if options.winMgr=="labwc" 
					then ./waybar/config-labwc.jsonc
					else ./waybar/config-niri.jsonc);
			};
			"waybar/style.css" = {
				force = true;
				source = ./waybar/style.css;
			};
			"waybar/modules.jsonc" = {
				force = true;
				source = ./waybar/modules.jsonc;
			}// 
			(if options.winMgr == "niri" then {
				"waybar/libniri_taskbar.so" = {
					force = true;
					recursive = false;
					source = "${niri-taskbar}/libniri_taskbar.so";
				};
			} else {});

			"mako/" = {
				force = true;
				recursive = true;
				source = ./mako;
			};
			"fuzzel/" = {
				force = true;
				recursive = true;
				source = ./fuzzel;
			};
		};	
	};
}


# services.mako.settings={
# 	"actionable=true" = {
# 		anchor = "bottom-left";
# 	};
# 	actions = true;
# 	anchor = "bottom-right";
# 	background-color = "#000000";
# 	border-color = "#FFFFFF";
# 	border-radius = 0;
# 	default-timeout = 0;
# 	font = "Maple Mono NF CN 10";
# 	height = 100;
# 	icons = true;
# 	ignore-timeout = false;
# 	layer = "top";
# 	margin = 10;
# 	markup = true;
# 	width = 300;
# };