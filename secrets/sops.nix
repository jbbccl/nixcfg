{ username, ...}:{
	sops.defaultSopsFile = ./secrets.yaml;
	sops.age.keyFile = "/root/.config/sops/age/keys.txt";

	sops.secrets.airport01URL = {};
	sops.secrets.airport02URL = {};
}