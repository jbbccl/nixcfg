{
	services.cockpit = {
		enable = true; # Enable the Cockpit service
		port = 9090; # Set the port for Cockpit (default is 9090)
		openFirewall = true; # Open the firewall for Cockpit access
		settings = {
			WebService = {
				AllowUnencrypted = true; # Allow unencrypted connections (optional)
			};
		};
	};
}