{
  pkgs,
  username,
  lib,
  config,
  ...
}: let
  cfg = config.apps.toolkits.disk;
in {
  options.apps.toolkits.disk.enable = lib.mkEnableOption "disk tools";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.partitionmanager
    ];


    home-manager.users.${username} = {
      home.packages = with pkgs; [
        kdePackages.filelight
        _7zz-rar
        peazip
        squashfsTools
      ];
    };
  };
}
