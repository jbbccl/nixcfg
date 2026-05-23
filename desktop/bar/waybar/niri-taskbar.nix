{ lib, pkgs }:
pkgs.rustPlatform.buildRustPackage {
	pname = "niri-taskbar";
	version = "2025.10.12";

	src = pkgs.stdenvNoCC.mkDerivation {
		name = "niri-taskbar-patched-src";
		src = pkgs.fetchFromGitHub {
			owner = "LawnGnome";
			repo = "niri-taskbar";
			rev = "c530349fae638141ec58a9d4db0816d950a9295a";
			hash = "sha256-PN+7s3KnbIdUSs+PmY3A80x//tIQu2aqaW/vN7gXTRU=";
		};
		phases = [ "unpackPhase" "patchPhase" "installPhase" ];
		postPatch = ''
			cp ${./Cargo.lock} Cargo.lock
			substituteInPlace Cargo.toml --replace-fail '>=25.11.0, <25.12.0' '>=26.4.0'
		'';
		installPhase = ''
			cp -r . $out
		'';
	};

	cargoHash = "sha256-5U25Px5BnhOdGStoceDEujGFOjFPexmwuzzwMdUBOss=";

	nativeBuildInputs = with pkgs; [ pkg-config pango gtk3 ];
	buildInputs = with pkgs; [ pkg-config pango gtk3 ];

	installPhase = ''
		cargo build --release
		mkdir -p $out/lib
		cp ./target/release/libniri_taskbar.so $out/lib/libniri_taskbar.so
	'';
}
