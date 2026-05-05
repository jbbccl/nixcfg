{ config, lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir;
in {
  config = lib.mkIf (builtins.elem "waybar" config.desktop.bar) (let
    niri-taskbar = pkgs.rustPlatform.buildRustPackage {
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
  in {
    environment.systemPackages = with pkgs; [
      waybar
      brightnessctl
      networkmanagerapplet
    #   networkmanager_dmenu
      pwvucontrol
    ];

    home-manager.users.${username} = {
      xdg.configFile = mkConfigDir "waybar" ./config
	  // {
        "waybar/libniri_taskbar.so" = {
          force = true;
          recursive = false;
          source = "${niri-taskbar}/libniri_taskbar.so";
        };
      };
    };
  });
}
