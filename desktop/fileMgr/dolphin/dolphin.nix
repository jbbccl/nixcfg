{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.fileMgr.dolphin;
in {
  options.desktop.fileMgr.dolphin.enable = lib.mkEnableOption "dolphin file manager";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.dolphin
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kio-admin
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kservice
      kdePackages.plasma-workspace
      kdePackages.qtwayland
      # kdePackages.breeze-icons
      shared-mime-info
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];

    xdg.portal.extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];

    environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    home-manager.users.${username} = {
      xdg.configFile."kdeglobals" = {
        force = true;
        text = ''
          [General]
          TerminalApplication=xterm
          TerminalService=false

          [Icons]
          Theme=Papirus-Dark
        '';
      };

      xdg.dataFile = {
        "kio/servicemenus/vscode-open.desktop" = {
          text = ''
            [Desktop Entry]
            Type=Service
            ServiceTypes=KonqPopupMenu/Plugin
            MimeType=inode/directory;application/octet-stream;
            Actions=openInVSCode

            [Desktop Action openInVSCode]
            Name=在 VSCode 中打开
            Icon=vscode
            Exec=code %f
          '';
        };
        "kio/servicemenus/zed-open.desktop" = {
          text = ''
            [Desktop Entry]
            Type=Service
            ServiceTypes=KonqPopupMenu/Plugin
            MimeType=inode/directory;application/octet-stream;
            Actions=openInZed

            [Desktop Action openInZed]
            Name=在 Zed 中打开
            Icon=zed
            Exec=zeditor %f
          '';
        };
      };
    };
  };
}
