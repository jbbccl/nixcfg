{ config, pkgs, username, ... }: 
{

# 允许非自由软件 
# nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
# "vmware-workstation"
# ];
# 因为闭源且图形化，不放入modules/virtual

# 这会自动处理内核模块注入、服务启动和 udev 规则
virtualisation.vmware.host.enable = true;

# (可选) 即使开启了 host，有时也建议显式安装 guest 工具以防万一
# virtualisation.vmware.guest.enable = true; 

users.users.${username}.extraGroups = [ "vmware" ];

# 4. (重要提示) 内核版本警告
# VMware 非常挑剔内核版本。
# 如果你使用的是最新的 Linux 6.8/6.9+ (zen/latest)，VMware 经常会编译失败。
# 推荐使用 LTS 内核 (默认为 linuxPackages)
# boot.kernelPackages = pkgs.linuxPackages; 
}