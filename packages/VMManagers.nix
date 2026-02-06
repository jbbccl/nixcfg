{ config, pkgs, username, ... }: 
{
## =========================
## 			VMware
## =========================

# virtualisation.vmware.host.enable = true;
# users.users.${username}.extraGroups = [ "vmware" ];

## =========================
## 		Virt-Manager
## =========================

programs.virt-manager.enable = true;

## =========================
## 		VirtualBox
## =========================

}