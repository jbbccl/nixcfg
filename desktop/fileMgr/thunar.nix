{ config, pkgs, lib, ... }:
lib.mkIf (builtins.elem "thunar" config.desktop.fileManager) {
	programs.thunar.enable = true;
	services.gvfs.enable = true;
	services.tumbler.enable = true;
}
