{ config, pkgs, username, ... }:

{

environment.systemPackages = with pkgs; [

	gcc         # 编译器
	gnumake     # Make 工具
	cmake       # CMake
	pkg-config  # 查找库的工具 (非常重要)

	# 安装库本身
	openssl

	# ⚠️ 关键：必须安装 openssl.dev 才能获得 .h 头文件
	openssl.dev 
];

# =================================================================
# 4. ⚠️ 关键步骤：全局暴露 OpenSSL 头文件和库路径
# =================================================================
# 因为 NixOS 没有 /usr/include，GCC 默认找不到全局安装的库。
# 我们需要设置环境变量让 GCC 知道去哪里找 OpenSSL。
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