{ pkgs, username, ... }:{
	environment.systemPackages = with pkgs; [
		wayvnc
		novnc
		wlr-randr
		#sunshine
	];
}
