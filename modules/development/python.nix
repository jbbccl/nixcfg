{ config, pkgs, lib, username, ... }:
lib.mkIf (builtins.elem "python" config.development.languages) {

	environment.systemPackages = with pkgs; [
		python3
		uv
	];

	home-manager.users.${username}.xdg.configFile."uv/uv.toml" = {
		text = ''
			[[index]]
			url = "https://pypi.tuna.tsinghua.edu.cn/simple"
			default = true
		'';
	};
}
