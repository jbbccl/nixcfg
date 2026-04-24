{ username, ... }: {
	networking = {
		hostName = "nixos";
		networkmanager.enable = true;
		networkmanager.wifi.backend = "iwd";
		nftables.enable = true;
		firewall = {
			enable = true;
			allowedTCPPorts = [
				53317
			];
			trustedInterfaces = [ "waydroid0" "virbr0" "Meta" ];
		};
	};
	users.users.${username}.extraGroups = [ "networkmanager" ];

	boot.kernel.sysctl = {
		"net.ipv4.ip_forward" = 1;
		"net.ipv4.conf.all.forwarding" = 1;
	};
}
