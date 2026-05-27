{ config, lib, ... }:
{
  imports = [
    ./base/__base__.nix
    ./dispMgr/__dispMgr__.nix
    ./winMgr/__winMgr__.nix
    ./bar/__bar__.nix
    ./launcher/__launcher__.nix
    ./lock/__lock__.nix
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
        winMgr.list = [ "labwc" "niri" ];
        bar.list = [ 
            "waybar" 
            # "noctalia"
        ];
        bar.waybar.niriTaskbar = true;
        launcher.select = "fuzzel";
        lock.select = "swaylock";
        notif.select = "mako";
        input.select = "fcitx5";
        dispMgr.select = "greetd";
        term.select = "kitty";
        fileMgr.list = [ "dolphin" "thunar" ];
      };
    })
  ];
}
