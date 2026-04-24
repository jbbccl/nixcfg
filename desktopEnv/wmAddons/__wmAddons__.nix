{ options, ... }:{
	imports = [
		./pty
		./fileMgr
		./inputMth
		./wallpaper
		(import ./statusBar/__bar__.nix { options = options; })
	];
}
