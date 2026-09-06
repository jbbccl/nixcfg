{
  config,
  lib,
  pkgs,
  username,
  inputs,
  ...
}: let
  cfg = config.apps.game.linuwowo;
  system = pkgs.stdenv.hostPlatform.system;
in {
  options.apps.game.linuwowo.enable =
    lib.mkEnableOption "LinUwUx Denuvo runtime (patched GE-Proton + cpuid_fault_emulation, AMD only)";

  config = lib.mkIf cfg.enable {
    # AMD-only: cpuid_fault_emulation 依赖 AMD CPUID faulting 仿真, 只在 AMD 游戏机开 (host/pc)
    programs.linuwowo = {
      enable = true;
      json = ./linuwowo.json;
      # 不随开机自载: 服务按需 start/stop, 避免第三方 ring0 模块常驻并抢占 KVM
      cpuidFaultEmulation.autoLoad = false;
    };

    # 把改版 GE-Proton 挂给 Steam/Heroic
    home-manager.users.${username} = {
      home.file = {
        ".config/heroic/tools/proton/GE-Proton11-1-LinUwUx-patch".source =
          inputs.linuwowo.packages.${system}.GE-Proton11-1-LinUwUx-patch;
        ".steam/root/compatibilitytools.d/GE-Proton11-1-LinUwUx-patch".source =
          inputs.linuwowo.packages.${system}.GE-Proton11-1-LinUwUx-patch;
      };
    };
  };
}
