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
      # nixpkgs 内核用 kmodigest 给每个模块签名并生成 .ko.cer,
      # 原包只手工 install .ko, 聚合器 cat 不到 .cer 会构建失败 → 改走 kbuild modules_install
      cpuidFaultEmulation.package = let
        kernel = config.boot.kernelPackages.kernel;
        moduleMakeFlags = kernel.commonMakeFlags ++ [
          "KBUILD_OUTPUT=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
          "DEPMOD=true"
          "INSTALL_MOD_STRIP=1"
        ];
      in
        (config.boot.kernelPackages.callPackage "${inputs.linuwowo.outPath}/cpuid-fault-emulation.nix" {})
        .overrideAttrs (_: {
          installPhase = ''
            make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD \
              ${lib.concatStringsSep " " (map lib.escapeShellArg moduleMakeFlags)} \
              INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=extra modules_install
          '';
        });
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
