{ config, lib, ... }:
lib.mkIf config.modules.development.enable {
	programs.git = {
		enable = true;

		config = {
			user = {
				name  = "lccbbj";
				email = "lccbbj@example.com";
			};
			init.defaultBranch = "main";
		};
	};
}