{ self, username, ... } :
{
# services.openssh.enable = true;
home-manager.users.${username} = {
	home.file = {
		".ssh/none" = {
			source = ./ssh.nix;
			force = true;
			recursive = true;
			onChange = ''
			cp -r ~/nixrc/static/_security/.ssh/  ~/
			'';
		};
	};
};

}
