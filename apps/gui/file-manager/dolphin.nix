{ config, pkgs, username, ... }:
let
	dolphinTerminal = pkgs.writeShellScriptBin "dolphin-terminal" ''
        exec ''${TERMINAL:-kitty} "$@"
    '';
in
{
	environment.systemPackages = with pkgs; [
		kdePackages.dolphin
		kdePackages.kio
		kdePackages.kio-extras
		kdePackages.kio-admin
		kdePackages.kdegraphics-thumbnailers
		kdePackages.kservice          # 提供 kbuildsycoca6
		kdePackages.plasma-workspace  # 提供 menu 文件
		kdePackages.qtwayland
		kdePackages.breeze-icons
		shared-mime-info
		xdg-desktop-portal
		xdg-desktop-portal-gtk        # 或 kde 的 portal
		# 如果用 Wayland + KDE portal
		# kdePackages.xdg-desktop-portal-kde
	];

	xdg.portal.extraPortals = [
		pkgs.kdePackages.xdg-desktop-portal-kde
	];

	environment.etc."xdg/menus/applications.menu".source = 
	"${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  	home-manager.users.${username} = {
		xdg.configFile = {
			"kdeglobals" = {
				force = true;
				text = ''
                    [General]
                    TerminalApplication=${dolphinTerminal}/bin/dolphin-terminal
                    TerminalService=false
                '';
			};
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
                    Icon=zeditor
                    Exec=zeditor %f
                '';
			};
		};
	};
}
