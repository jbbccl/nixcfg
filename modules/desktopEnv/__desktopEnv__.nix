{
	imports = [
		./fictx5
		./pty
		./fileMgr

		./displayMgr
		
		# ./noctalia #只要安装了noctalia, 即使不运行, 应用启动会慢1秒。
		./waybar/waybar.nix

		./niri/niri.nix
		# ./plasma
		# ./xfce
		
		./theme.nix
		./broser.nix
  ];
}
