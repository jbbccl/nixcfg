{ pkgs, ... }:{
	environment.systemPackages = [
		pkgs.litellm
	];
}