{ self, config, lib, pkgs, username, ... }:
lib.mkIf config.secrets.available {

# nix-shell -p apacheHttpd --run 'htpasswd -B -n dabianchaoren'
	sops.secrets.nginx-basic-auth-hash = {
		sopsFile = "${self}/secrets/token.yaml";
		mode = "0400";
		owner = "nginx";
		group = "nginx";
	};

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
			# addSSL = true;
			forceSSL = true;
			sslCertificate = "/etc/nginx/ssl/cert.pem";
			sslCertificateKey = "/etc/nginx/ssl/key.pem";
			listen = [
				{ addr = "[::]"; port = 49514; ssl = true; }
				# { addr = "127.0.0.1"; port = 80; }
				# { addr = "127.0.0.1"; port = 443; ssl = true; }
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

	system.activationScripts.nginx-ssl-cert = ''
		if [ ! -f /etc/nginx/ssl/cert.pem ]; then
			mkdir -p /etc/nginx/ssl
			chown root:nginx /etc/nginx/ssl
			chmod 755 /etc/nginx/ssl
			${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 \
				-keyout /etc/nginx/ssl/key.pem \
				-out /etc/nginx/ssl/cert.pem \
				-days 365 -nodes \
				-subj "/CN=1.ccb"
			chown root:nginx /etc/nginx/ssl/key.pem /etc/nginx/ssl/cert.pem
			chmod 644 /etc/nginx/ssl/cert.pem
			chmod 640 /etc/nginx/ssl/key.pem
		fi
	'';
}
