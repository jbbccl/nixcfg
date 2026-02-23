# ！sudo会重置环境变量, 导致不走代理, 第一次构建使用sudo -E
# sudo nixos-rebuild switch --flake ~/nixrc#lap
# 使用缓存
# sudo nixos-rebuild switch --flake ~/nixrc#lap --option substituters ""
# 使用官方源sudo NIX_CONFIG="substituters = https://cache.nixos.org" nixos-re..
# sudo nixos-rebuild switch --flake ~/nixrc#lap --option substituters "https://cache.nixos.org"
# 测试
# nix flake check ~/nixrc
# 更新
# nix flake update
# nix flake lock --update-input noctalia
# 清理
# sudo nix-collect-garbage -d
{

inputs = {
	nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
	nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
	nixpkgs-master.url = "github:NixOS/nixpkgs/master";#"git+ssh://git@github.com/NixOS/nixpkgs?ref=master";#

	nixpkgs.follows = "nixpkgs-unstable";
	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};
	#edit:
	# flake-parts.url = "github:hercules-ci/flake-parts";
	mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	noctalia = {
		url = "github:noctalia-dev/noctalia-shell";
		inputs.nixpkgs.follows = "nixpkgs";
	};
	agenix.url = "github:ryantm/agenix";
	# catppuccin.url = "github:catppuccin/nix";#/release-25.11";
};

outputs = inputs@{ 
	self,
	nixpkgs,
	home-manager,
	agenix,
	# catppuccin,
	... }: let
    username = "e";
in{

	nixosConfigurations.lap = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
			# edit: 
			inputs.mango.nixosModules.mango
			# catppuccin.nixosModules.catppuccin
			agenix.nixosModules.default

			{
				home-manager.users.${username} = {
					imports = [
						inputs.mango.hmModules.mango
						# catppuccin.homeModules.catppuccin
					];
				};
			}
			# stable: 
			./host/lap/configuration.nix
			home-manager.nixosModules.home-manager
			{
				nixpkgs.overlays = [
					(final: prev: {
						stable = import inputs.nixpkgs-stable {
							system = prev.stdenv.hostPlatform.system;
							config.allowUnfree = true;
						};
						unstable = import inputs.nixpkgs-unstable {
							system = prev.stdenv.hostPlatform.system;
							config.allowUnfree = true;
						};
						master = import inputs.nixpkgs-master {
							system = prev.stdenv.hostPlatform.system;
							config.allowUnfree = true;
						};
					})
				];
			}
		];
		specialArgs = {
			_config_ = "lap";
			username = username;
			inherit self inputs;
		};
	};

	# ========pc========

	nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
			# edit: 
			agenix.nixosModules.default

			{
				home-manager.users.${username} = {
				imports = [];
				};
			}
			# stable: 
			./host/lap/configuration.nix
			home-manager.nixosModules.home-manager
			{
				nixpkgs.overlays = [
					(final: prev: {
						stable = import inputs.nixpkgs-stable {
							system = prev.stdenv.hostPlatform.system;
							config.allowUnfree = true;
						};
						unstable = import inputs.nixpkgs-unstable {
							system = prev.stdenv.hostPlatform.system;
							config.allowUnfree = true;
						};
						master = import inputs.nixpkgs-master {
							system = prev.stdenv.hostPlatform.system;
							config.allowUnfree = true;
						};
					})
				];
			}
		];
		specialArgs = {
			_config_ = "pc";
			username = username;
			inherit self inputs;
		};
	};

};

}