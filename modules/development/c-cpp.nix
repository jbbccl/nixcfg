{ config, pkgs, lib, username, ... }:
lib.mkIf (builtins.elem "c-cpp" config.modules.development.languages) {

	environment.systemPackages = with pkgs; [
		gcc
		gnumake
		cmake
		gdb
		pkg-config

		openssl.dev
	];

	environment.variables = {
		PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
		C_INCLUDE_PATH = "${pkgs.openssl.dev}/include";
		CPLUS_INCLUDE_PATH = "${pkgs.openssl.dev}/include";
		LIBRARY_PATH = "${pkgs.openssl.out}/lib";
	};
}
