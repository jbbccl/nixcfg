{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.services.xserver.enable = lib.mkEnableOption "xserver (xkb)";

  config = lib.mkIf config.modules.services.xserver.enable {
    services.xserver = {
      xkb = {
        layout = "us";
        options = "caps:swapescape";
      };
    };
  };
}
