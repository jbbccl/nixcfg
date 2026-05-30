{ config, lib, ... }:
{
  imports = [
    ./base/__base__.nix
    ./dispMgr/__dispMgr__.nix
    ./winMgr/__winMgr__.nix
    ./bar/__bar__.nix
    ./launcher/__launcher__.nix
    ./lock/__lock__.nix
    ./pwmenu/__pwmenu__.nix
    ./notif/__notif__.nix
    ./input/__input__.nix
    ./wallpaper/__wallpaper__.nix
    ./term/__term__.nix
    ./fileMgr/__fileMgr__.nix
    ./browser/__browser__.nix
    # ./session/__session__.nix  # plasma/xfce full DE, conflicts with WM
  ];

  options.desktop.enable = lib.mkEnableOption "desktop environment (WM, bar, DM, theme, etc.)";

  config = lib.mkMerge [
    { desktop.enable = lib.mkDefault true; }
    (lib.mkIf config.desktop.enable {
      desktop = lib.mkDefault {
        base.theme = "manual";
        winMgr.list = [ "labwc" "niri" ];
        bar.list = [ 
            # "waybar" 
            # "ironbar"
            "noctalia"
        ];
        # ---
        # bar.waybar.niriTaskbar = true;
        # lock.select = "swaylock";
        # pwmenu.select = "wlogout";
        # notif.select = "mako";
        # ---
        input.select = "fcitx5";
        launcher.select = "fuzzel";
        dispMgr.select = "greetd";
        term.select = "kitty";
        fileMgr.list = [ "dolphin" "thunar" ];
        wallpaper.enable = true;
      };
    })
  ];
}
