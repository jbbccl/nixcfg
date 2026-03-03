# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, lib, pkgs, ... }:
{
	imports = [
		./hardware-configuration.nix
		./driver.nix
		./boot.nix
		../../setting/__setting__.nix
		../../modules/__modules__.nix
		../../desktopEnv/__desktopEnv__.nix
		../../guiToolkit/__guiToolkit__.nix
		
	];

	system.stateVersion = "25.11";
}



	# 复制 NixOS 配置文件并链接到生成系统中(/run/current-system/configuration.nix)
	# 这在意外删除 configuration.nix 时很有用
	# system.copySystemConfiguration = true;

# 此选项定义了您在此特定机器上安装的第一个 NixOS 版本，
# 并用于保持与旧版 NixOS 创建的应用数据（例如数据库）的兼容性。
# 大多数用户在任何情况下都不应在初始安装后更改此值，
# 即使您已将系统升级到新的 NixOS 版本。
# 此值不会影响您获取软件包和操作系统的 Nixpkgs 版本，
# 因此更改它不会升级您的系统 - 有关如何实际升级，请参阅 https://nixos.org/manual/nixos/stable/#sec-upgrading for how
# 此值低于当前 NixOS 版本并不意味着您的系统 已过时、不受支持或易受攻击。
# 除非您已手动检查了它将给您的配置带来的所有更改，并相应地迁移了您的数据，否则请勿更改此值。
# 更多信息，请参阅 `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
