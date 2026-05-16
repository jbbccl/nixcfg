{ pkgs, ... }:{
	programs.steam = {
		enable = true; # Master switch, already covered in installation
		remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
		# Other general flags if available can be set here.
		extraCompatPackages = with pkgs; [
			proton-ge-bin
		];
	};

	environment.systemPackages = with pkgs; [
		steam-run
		protonup-qt
	];
}