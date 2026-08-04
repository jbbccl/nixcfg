{
  config,
  pkgs,
  ...
}: {
  hardware.enableRedistributableFirmware = true;
  services.thermald.enable = true; # 温控
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
