{ self, username, config, lib, ... } :
{
	sops.secrets = lib.mkIf config.secrets.available {
		github = {
			sopsFile = "${self}/secrets/ssh_keys.yaml";
			mode = "0600";
			owner = "${username}";
			group = "users";
		};
	};

	home-manager.users.${username}.home.file.".ssh/config" = lib.mkIf config.secrets.available {
		text = ''
        Host github.com
            HostName github.com
            User git
            IdentityFile ${config.sops.secrets.github.path}
            IdentitiesOnly yes
        '';
	};
}
