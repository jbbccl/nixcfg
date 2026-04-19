{ self, username, config, ... } :
{
# services.openssh.enable = true;
	home-manager.users.${username} = {
		home.file = {
			".ssh/config" = {
				text=''
				Host github.com
					HostName github.com
					User git
					IdentityFile ${config.sops.secrets."github".path}
					IdentitiesOnly yes
				'';
			};
		};
	};
}
