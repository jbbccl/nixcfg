{ config, pkgs, username, ... }: 
{
## =========================
## 			VMware
## =========================
# 因为闭源且图形化，不放入modules/virtual
# nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
# "vmware-workstation"
# ];
# 这会自动处理内核模块注入、服务启动和 udev 规则
virtualisation.vmware.host.enable = true;
# virtualisation.vmware.guest.enable = true; 
users.users.${username}.extraGroups = [ "vmware" ];
# boot.kernelPackages = pkgs.linuxPackages; 

## =========================
## 		Virt-Manager
## =========================
# qemu/kvm图形化管理工具
programs.virt-manager.enable = true;

## =========================
## 		VirtualBox
## =========================

}