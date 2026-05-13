{ config, pkgs, lib, ... }:
lib.mkIf (config.desktop.fileManager == "thunar") {
	programs.thunar.enable = true;
	services.gvfs.enable = true;
	services.tumbler.enable = true;
}
