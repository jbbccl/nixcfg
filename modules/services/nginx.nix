{ pkgs, username, ... }:{
		services.nginx = {
		enable = true;
		recommendedProxySettings = true;

		virtualHosts."1.ccb" = {
			default = true;
			basicAuth = { dabian = "LKDisadpoOSODPAdioAPDKJ"; };
			forceSSL = true;
			#TODO
			sslCertificate = "/etc/nginx/ssl/cert.pem";
			sslCertificateKey = "/etc/nginx/ssl/key.pem";

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

	networking.firewall.allowedTCPPorts = [ 80 443 ];
}
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