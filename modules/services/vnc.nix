{ pkgs, ... }:{
	environment.systemPackages = with pkgs; [
		wayvnc
		novnc
		wlr-randr
	];
}
