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
    ];

    xdg.portal.extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];

    environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    home-manager.users.${username} = {
      # xdg.configFile."dolphinrc" = {
      #   force = false;
      #   text = ''
      #     MenuBar=Disabled

      #     [ContextMenu]
      #     ShowCopyToOtherSplitView=false
      #     ShowDuplicateHere=false
      #     ShowMoveToOtherSplitView=false
      #     ShowSortBy=false
      #     ShowViewMode=false

      #     [DetailsMode]
      #     PreviewSize=22

      #     [General]
      #     Version=202
      #     ViewPropsTimestamp=2026,2,9,20,51,21.019
      #     TerminalApplication=xterm
      #     TerminalService=false

      #     [KFileDialog Settings]
      #     Places Icons Auto-resize=false
      #     Places Icons Static Size=22

      #     [MainWindow]
      #     MenuBar=Disabled

      #     [PreviewSettings]
      #     Plugins=appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,directorythumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,opendocumentthumbnail,svgthumbnail,windowsexethumbnail,windowsimagethumbnail

      #     [Icons]
      #     Theme=Papirus-Dark

      #     [UiSettings]
      #     ColorScheme=BreezeDark
      #   '';
      # };

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
