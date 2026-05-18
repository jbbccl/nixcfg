{ config, lib, pkgs, username, ... }: {
  config = lib.mkIf (builtins.elem "mangowc" config.desktop.windowManager) {
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
