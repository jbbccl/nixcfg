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
		# networkmanagerapplet
		networkmanager_dmenu

		pwvucontrol
	];

	home-manager.users.${username} = {
		xdg.configFile = {
			"waybar/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
			"waybar/libniri_taskbar.so" = {
				force = true;
				recursive = false;
				source = "${niri-taskbar}/libniri_taskbar.so";
			};
		};
	};
}
