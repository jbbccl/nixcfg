{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.winMgr.labwc;
in {
  options.desktop.winMgr.labwc.enable = lib.mkEnableOption "labwc window manager";

  config = lib.mkIf cfg.enable {
    programs.labwc.enable = true;
    environment.systemPackages = with pkgs; [
      wlr-randr
      xwayland-satellite
    ];
    home-manager.users.${username} = {
      dconf.settings = {
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
        };
      };
      xdg.configFile."labwc/" = {
        force = true;
        recursive = true;
        source = ./config;
      };
      home.file.".local/share/themes/" = {
        force = true;
        recursive = true;
        source = ./themes;
      };
    };
    xdg.portal = {
      extraPortals = with pkgs; [xdg-desktop-portal-wlr];
      config = {
        labwc = {
          default = ["wlr" "gtk"];
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.AppChooser" = "gtk";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        };
      };
    };

    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        labwc = {
          prettyName = "Labwc";
          comment = "Labwc compositor managed by UWSM";
          binPath = "${lib.getExe pkgs.labwc}";
        };
      };
    };
  };
}
