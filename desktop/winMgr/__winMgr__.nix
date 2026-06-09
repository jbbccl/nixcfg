{ config, lib, pkgs, username, ... }:
let
	mkWmEnable = name: lib.mkDefault (builtins.elem name config.desktop.winMgr.list);
in
{
  imports = [
    ./base/__base__.nix
    ./niri/niri.nix
    ./hypr/hypr.nix
    ./labwc/labwc.nix
    ./mangowc/mangowc.nix
  ];

  options.desktop.winMgr.list = lib.mkOption {
    type = lib.types.listOf (lib.types.enum [ "niri" "labwc" "hypr" "mangowc" ]);
    default = [];
    description = "window managers";
  };

  config = lib.mkIf (config.desktop.winMgr.list != []) {
    desktop.winMgr.base.enable    = lib.mkDefault true;
	desktop.winMgr.niri.enable    = mkWmEnable "niri";
	desktop.winMgr.labwc.enable   = mkWmEnable "labwc";
	desktop.winMgr.hypr.enable    = mkWmEnable "hypr";
	desktop.winMgr.mangowc.enable = mkWmEnable "mangowc";
  };
}
