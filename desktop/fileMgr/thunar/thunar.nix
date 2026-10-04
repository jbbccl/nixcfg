{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.fileMgr.thunar;
in {
  options.desktop.fileMgr.thunar.enable = lib.mkEnableOption "thunar file manager";

  config = lib.mkIf cfg.enable {
    programs.thunar.enable = true;
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    # home-manager 的 xdg.mimeApps 在本机没启用
    xdg.mime.defaultApplications."inode/directory" = "thunar.desktop";

    home-manager.users.${username} = {
    	xdg.configFile."Thunar/uca.xml" = {
    		force = true;
    		recursive = true;
    		source = ./uca.xml;
    	};

    };
  };
}
