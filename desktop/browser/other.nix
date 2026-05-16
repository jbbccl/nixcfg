{ pkgs, ... }:{
	# programs.firefox.enable = true;	# 15
	environment.systemPackages = with pkgs; [
		# ungoogled-chromium	# 20
		brave		# 25
		# librewolf
		# floorp-bin	# 11.5
	];
}