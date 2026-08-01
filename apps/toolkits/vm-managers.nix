{
  config,
  pkgs,
  username,
  lib,
  ...
}: let
  cfg = config.apps.toolkits.vm-managers;
in {
  options.apps.toolkits.vm-managers.enable = lib.mkEnableOption "virt-manager";

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;
  };
}
