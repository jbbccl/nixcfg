{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.winMgr.mangowc;
in
{
	options.desktop.winMgr.mangowc.enable = lib.mkEnableOption "mangowc window manager";

	config = lib.mkIf cfg.enable {
    programs.mango.enable = true;

    xdg.portal = {
      extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
      config = {
        mangowc = {
          default = [ "wlr" "gtk" ];
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        };
      };
    };
  };
}
