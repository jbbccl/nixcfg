{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.toolkits.rs;
in {
  options.apps.toolkits.rs.enable = lib.mkEnableOption "remote sensing tools (qgis, otb)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qgis
      otb
    ];
  };
}
