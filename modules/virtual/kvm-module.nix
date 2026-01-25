{ config, pkgs, username, ... }:

{
  # 1. 启用 Libvirt 守护进程 (管理 KVM 的核心)
  virtualisation.libvirtd = {
    enable = true;
    # 可选：让它在关机时挂起虚拟机而不是直接断电
    onShutdown = "suspend";
  };

  # 2. 启用 Virt-Manager (图形化管理工具)
  programs.virt-manager.enable = true;

  # 3. 必须安装 QEMU
  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    OVMFFull  # UEFI 固件支持
  ];

  # 4. 权限设置
  # 将当前用户加入 libvirtd 组，否则打开 virt-manager 会没有权限连接
  users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];
  
  # 5. (可选) 开启嵌套虚拟化 (如果你要在虚拟机里再跑虚拟机)
  # boot.extraModprobeConfig = "options kvm_intel nested=1";
}