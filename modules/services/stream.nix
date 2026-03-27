{ pkgs, ... }:{
	environment.systemPackages = with pkgs; [
		sunshine
	];
	# sun pass
}
