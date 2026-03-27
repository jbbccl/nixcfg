{ config, pkgs, username, ... }:
{

	environment.systemPackages = with pkgs; [
		gcc
		gnumake
		cmake
		gdb
		pkg-config

		openssl
		openssl.dev
	];

	environment.variables = {
		# 让 pkg-config 能找到 openssl.pc
		PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

		# 让 GCC 能找到 #include <openssl/...>
		# C_INCLUDE_PATH 对 C 语言有效，CPLUS_INCLUDE_PATH 对 C++ 有效
		C_INCLUDE_PATH = "${pkgs.openssl.dev}/include";
		CPLUS_INCLUDE_PATH = "${pkgs.openssl.dev}/include";

		# 让链接器能找到 -lssl -lcrypto
		LIBRARY_PATH = "${pkgs.openssl.out}/lib";
	};
}
