{ config, lib, pkgs, ... }:
let
    cfg = config.desktop.winMgr.base.xdg;
in
{
    options.desktop.winMgr.base.xdg.enable = lib.mkEnableOption "XDG portals for WM";

    config = lib.mkIf cfg.enable {
        xdg = {
          mime.enable = true;
          menus.enable = true;
        };
        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
          extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal ];
          config = {};
        };
    };
}