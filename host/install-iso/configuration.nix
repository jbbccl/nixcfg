# host/install-iso/configuration.nix — offline installer ISO with full desktop
#
# Build: nix build .#nixosConfigurations.install-iso.config.system.build.isoImage
# Usage: dd to USB → boot → tuigreet login → niri → partitionmanager → install
# 安装步骤: ISO 内 /etc/nixos/INSTALL.txt
{
  self,
  inputs,
  username,
  lib,
  pkgs,
  ...
}: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"

    ../../core/__core__.nix
    ../../secrets/__secrets__.nix
    ../../modules/shells/__shells__.nix
    ../../desktop/__desktop__.nix
    ../../apps/cli/__cli__.nix
    ../../apps/services/ai/__ai__.nix
  ];

  # 有意为之: hm 在开机激活阶段执行, 确保 systemd --user 读取 environment.d 前文件已就绪
  home-manager.startAsUserService = false;

  core.user.username = "nixos";
  users.users.${username}.initialPassword = lib.mkForce "pass";

  modules.shells.enable = true;
  modules.shells.fish.enable = true;

  desktop.browser.firefox.enable = false;

  # ISO 无 age key: sops 渲染报 failed unit 但不影响运行, opencode 用免费额度应急
  apps.services.ai.enable = true;
  apps.services.ai.opencode.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    flclash
  ];

  environment.etc."nixos/flake".source = self;
  environment.etc."nixos/INSTALL.txt".text = ''
    mount /dev/xx /mnt
    cp -r /etc/nixos/flake /mnt/etc/nixos
    nixos-generate-config --root /mnt
    cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/host/lap/
    nixos-install --no-root-passwd --flake /mnt/etc/nixos#lap --root /mnt
  '';
}
