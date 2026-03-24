{ options, ... }:{
	imports = [
		./pty
		./fileMgr
		./inputMth
		(import ./statusBar/__bar__.nix { options = options; })
	];
}
