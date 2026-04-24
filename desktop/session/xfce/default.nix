{ config, pkgs, callPackage, ... }: {
	services.xserver = {
		enable = true;
		displayManager.startx.enable = true;

		desktopManager = {
			xterm.enable = false;
			xfce.enable = true;
		};
	};
	services.displayManager.defaultSession = "xfce";
	environment.systemPackages = [
		pkgs.xfce4-whiskermenu-plugin
	];
	nixpkgs.overlays = [
    (final: prev: {
      xfce = prev.xfce.overrideScope (xfceFinal: xfcePrev: {
        xfce4-session = xfcePrev.xfce4-session.overrideAttrs (old: {
          # 在安装完成后，将 xfce4-session 替换为 startxfce4
          postInstall = (old.postInstall or "") + ''
          	sed -i 's/^Exec=.+/Exec=startxfce4/' $out/share/xsessions/xfce.desktop
          '';
        });
      });
    })
  ];

  # 确保 startx 可用
  # services.xserver.displayManager.startx.enable = true;

}
