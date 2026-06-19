{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wallpaper.awww;
in {
  options.desktop.wallpaper.awww.enable = lib.mkEnableOption "awww animated wallpaper engine";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.awww];
  };
}
