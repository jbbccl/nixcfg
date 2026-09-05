{
  config,
  pkgs,
  ...
}: {
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    # enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd # AMD OpenCL (Navi 24 / RX 6500 XT)
      pocl # CPU OpenCL 兜底
    ];
  };
  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];
  # gfx1033 不在 ROCm 官方支持矩阵, 按 gfx1030 跑
  environment.sessionVariables.HSA_OVERRIDE_GFX_VERSION = "10.3.0";

  # networking.interfaces.enp0s3.macAddress = "00:11:22:33:44:55";
}
