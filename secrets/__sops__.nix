{ username, ...}:{
	sops.defaultSopsFile = ./secrets.yaml;
	sops.age.keyFile = "/root/.config/sops/age/keys.txt";

	sops.secrets.airport01URL = {
		sopsFile = ./token.yaml;
	};
	sops.secrets.airport02URL = {
		sopsFile = ./token.yaml;
	};
	sops.secrets.airport03URL = {
		sopsFile = ./token.yaml;
	};

	sops.secrets.litellm-env = {
		sopsFile = ./api_keys.yaml;
		owner = "${username}";
		group = "users";
		mode = "0400";
	};

	sops.secrets.github = {
		sopsFile = ./ssh_keys.yaml; 
		mode = "0600";
		owner = "${username}";
		group = "users";
		# path = "/home/${username}/.ssh/github";
	};
}