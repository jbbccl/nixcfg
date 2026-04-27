{ pkgs, username, ... }:{
	home-manager.users.${username} = {
		home.packages = with pkgs; [
			squashfsTools
			fastfetch
			btop
			# ocamlPackages.cpdf
			openssl
		];
	};
}