{ config, pkgs, lib, username, ... }:
lib.mkIf (builtins.elem "rust" config.modules.development.languages) {
	
	home-manager.users.${username} = {
		home.packages = with pkgs; [
			rustup
			pkg-config
			# GUI 开发依赖（gtk4-rs 等），重，按需取消注释
			# pango
			# gtk3
		];
		home.sessionVariables = {
			RUSTUP_HOME = "$HOME/.rustup";
			CARGO_HOME = "$HOME/.cargo";
			RUSTUP_DIST_SERVER = "https://rsproxy.cn";
			RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
		};
	};
}
