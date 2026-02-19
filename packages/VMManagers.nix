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

# virtualisation.virtualbox.host.enable = true;
# users.extraGroups.vboxusers.members = [ "${username}" ];

# # nixpkgs.config.allowUnfree = true;
# virtualisation.virtualbox.host.enable = true;
# virtualisation.virtualbox.host.enableExtensionPack = true;

}