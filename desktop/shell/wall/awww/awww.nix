{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.shell.wall.awww;
in {
  options.desktop.shell.wall.awww.enable = lib.mkEnableOption "awww animated wallpaper engine";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.awww];
  };
}
