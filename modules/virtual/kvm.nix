{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.modules.virtual.kvm;
in {
  options.modules.virtual.kvm.enable = lib.mkEnableOption "KVM virtualization (libvirtd)";

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      onShutdown = "suspend";
    };

    systemd.services.libvirtd = {
      wantedBy = lib.mkForce [];
      postStart = ''
        ${pkgs.libvirt}/bin/virsh net-start default 2>/dev/null || true
      '';
    };

    environment.systemPackages = with pkgs; [
      qemu
      qemu_kvm
      OVMFFull
    ];

    networking.firewall.trustedInterfaces = ["virbr0"];

    users.users.${username}.extraGroups = ["libvirtd" "kvm"];
  };
}
