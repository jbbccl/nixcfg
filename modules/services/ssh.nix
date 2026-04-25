{ self, username, config, lib, ... } :
{
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
