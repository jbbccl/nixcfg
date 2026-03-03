{ self, username, ... } :
{
# services.openssh.enable = true;
	home-manager.users.${username} = {
		home.file = {
			".ssh/config" = {
				text=''
				Host github.com
					HostName github.com
					User git
					IdentityFile ~/.ssh/github
					IdentitiesOnly yes
				'';
			};
		};
	};
}
