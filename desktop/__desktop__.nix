{
  imports = [
    ./theme.nix
    ./display-manager/__displayMgr__.nix
    ./window-manager/__winMgr__.nix
    ./status-bar/__bar__.nix
    ./launcher/__launcher__.nix
    ./lock/__lock__.nix
    ./notification/__notification__.nix
    ./input/__input__.nix
    ./wallpaper/__wallpaper__.nix
    # ./session/__session__.nix  # plasma/xfce full DE, conflicts with WM
  ];
}
