{ config, lib, username, ... }: {
  config = lib.mkIf (config.desktop.windowManager == "mangowc") {
	programs.mango.enable = true;
  };
}
