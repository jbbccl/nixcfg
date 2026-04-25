{ pkgs, username, ... }: {
	home-manager.users.${username} = {
		home.packages = with pkgs; [

		];
	# XDG_DATA_DIRS = "$XDG_DATA_DIRS:${config.home.homeDirectory}/custom-dir";
	};
	# environment.pathsToLink = [ "/share/applications" ];
	#xdg.dataFile."applications".source = "/opt/toolkit/.Launch";
	environment.sessionVariables = rec {
		PATH = [ "/opt/toolkit/ass/bin" ];
		XDG_DATA_DIRS = [ "/opt/toolkit/ass/" ];
	};
}
