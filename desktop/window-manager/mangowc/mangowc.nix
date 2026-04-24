{ config, lib, username, ... }: {
  config = lib.mkIf (builtins.elem "mangowc" config.desktop.windowManager) {
	programs.mango.enable = true;
  };
}
