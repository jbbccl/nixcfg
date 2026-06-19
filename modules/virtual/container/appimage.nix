{
  config,
  lib,
  ...
}: let
  cfg = config.modules.virtual.container.appimage;
in {
  options.modules.virtual.container.appimage.enable = lib.mkEnableOption "Flatpak & AppImage support";

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
