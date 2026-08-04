{
  config,
  lib,
  ...
}: {
  options.modules.services.xkb.enable = lib.mkEnableOption "xkb keymap (us + caps:swapescape)";

  config = lib.mkIf config.modules.services.xkb.enable {
    services.xserver.xkb = {
      layout = "us";
      options = "caps:swapescape";
    };
  };
}
