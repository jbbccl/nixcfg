{ pkgs, username, ... }:{
		services.nginx = {
		enable = true;
		recommendedProxySettings = true;

		virtualHosts."1.ccb" = {
			default = true;
			basicAuth = { dabianchaoren = "JHshduSAYD*)(*SD#quh298jjsHODJFSHF*(3j2poijNWJKLSDF))"; };
			forceSSL = true;
			#TODO
			sslCertificate = "/etc/nginx/ssl/cert.pem";
			sslCertificateKey = "/etc/nginx/ssl/key.pem";
			listen = [
				# { addr = "0.0.0.0"; port = 49514; ssl = true; }
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
# https://[240e:467:573:241f:b584:8f77:a07b:29a8]:49514
# sudo mkdir -p /etc/nginx/ssl/
# sudo chown root:nginx /etc/nginx/ssl/
# sudo chmod 755 /etc/nginx/ssl/

# sudo openssl req -x509 -newkey rsa:4096 \
#         -keyout /etc/nginx/ssl/key.pem \
#         -out /etc/nginx/ssl/cert.pem \
#         -days 365 -nodes \
#         -subj "/CN=1.ccb"
        
# sudo chown root:nginx /etc/nginx/ssl/key.pem /etc/nginx/ssl/cert.pem
# sudo chmod 644 /etc/nginx/ssl/cert.pem
# sudo chmod 640 /etc/nginx/ssl/key.pem