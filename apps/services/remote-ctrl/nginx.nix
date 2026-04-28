{ config, lib, pkgs, username, ... }:
lib.mkIf config.secrets.available {

	sops.templates."nginx-htpasswd" = {
		owner = "nginx";
		group = "nginx";
		mode = "0400";
		content = lib.replaceStrings
			[ "BASIC_AUTH_HASH_PLACEHOLDER" ]
			[ config.sops.placeholder."nginx-basic-auth-hash" ]
			"dabianchaoren:BASIC_AUTH_HASH_PLACEHOLDER";
	};

	services.nginx = {
		enable = true;
		recommendedProxySettings = true;

		virtualHosts."1.ccb" = {
			default = true;
			basicAuthFile = config.sops.templates."nginx-htpasswd".path;
			forceSSL = true;
			sslCertificate = "/etc/nginx/ssl/cert.pem";
			sslCertificateKey = "/etc/nginx/ssl/key.pem";
			listen = [
				{ addr = "[::]"; port = 49514; ssl = true; }
			];

			locations."/" = {
				proxyPass = "http://127.0.0.1:6080";
				proxyWebsockets = true;
				extraConfig =
					"proxy_ssl_server_name on;" +
					"proxy_pass_header Authorization;"
				;
			};
		};
	};

	networking.firewall.allowedTCPPorts = [ 49514 ];
}
