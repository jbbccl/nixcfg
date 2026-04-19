{ username, ...}:{
	sops.defaultSopsFile = ./secrets.yaml;
	sops.age.keyFile = "/root/.config/sops/age/keys.txt";

	sops.secrets.airport01URL = {};
	sops.secrets.airport02URL = {};
	sops.secrets.airport03URL = {};
	sops.secrets.github = {
		mode = "0600";
		owner = username;
		group = "users";
		# path = "/home/${username}/.ssh/github";
	};
}