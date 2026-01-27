{ config, pkgs, username, ... }:

{
# 1. 启用 Libvirt 守护进程 (管理 KVM 的核心)
virtualisation.libvirtd = {
	enable = true;
	# 可选：让它在关机时挂起虚拟机而不是直接断电
	onShutdown = "suspend";
};

# Virt-Manager 图形化,放到packages中
# programs.virt-manager.enable = true;

environment.systemPackages = with pkgs; [
	qemu
	qemu_kvm
	OVMFFull  # UEFI 固件支持
];

users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];

# 开启嵌套虚拟化
# boot.extraModprobeConfig = "options kvm_intel nested=1";
}