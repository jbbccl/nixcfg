# ！sudo会重置环境变量, 导致不走代理, 第一次构建使用sudo -E
# sudo nixos-rebuild switch --flake ~/nixrc#lap
# NIX_CONFIG="substituters = https://cache.nixos.org" 或  --option substituters "" 
# sudo nixos-rebuild switch --flake ~/nixrc#lap --option substituters ""
# sudo nixos-rebuild switch --flake ~/nixrc#lap --option substituters "https://cache.nixos.org"
# nix flake check ~/nixrc
# nix flake update
# nix flake lock --update-input noctalia
# 清理
# sudo nix-collect-garbage -d
{
description = "Optimized NixOS Flake Configuration";

inputs = {
	nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
	nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11"; 
	nixpkgs-master.url = "github:NixOS/nixpkgs/master";

	nixpkgs.follows = "nixpkgs-unstable";

	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	mango = {
		url = "github:DreamMaoMao/mango";
		inputs.nixpkgs.follows = "nixpkgs";
	};
	
	noctalia = {
		url = "github:noctalia-dev/noctalia-shell";
		inputs.nixpkgs.follows = "nixpkgs";
	};
	
	agenix.url = "github:ryantm/agenix";
	# catppuccin.url = "github:catppuccin/nix";
};

outputs = inputs@{ 
	self, 
	nixpkgs, 
	home-manager, 
	agenix, 
	... 
}:
let
	username = "e";
	system = "x86_64-linux";

	sharedOverlays = [
		(final: prev: {
			stable = import inputs.nixpkgs-stable {
				inherit system;
				config.allowUnfree = true;
			};
			unstable = import inputs.nixpkgs-unstable {
				inherit system;
				config.allowUnfree = true;
			};
			master = import inputs.nixpkgs-master {
				inherit system;
				config.allowUnfree = true;
			};
		})
	];
	# 通用
	mkSystem = { hostName, extraModules ? [] }: nixpkgs.lib.nixosSystem {
		inherit system;

		specialArgs = {
			inherit self inputs username;
			_config_ = hostName;
		};

		modules = [
			./host/${hostName}/configuration.nix
			home-manager.nixosModules.home-manager
			{ nixpkgs.overlays = sharedOverlays; }
			{
				home-manager.users.${username} = {
					home.stateVersion = "25.11";
					imports = [];
				};
				# home-manager.useGlobalPkgs = true;
				# home-manager.useUserPackages = true;
			}
		] ++ extraModules;
	};
in
{
	nixosConfigurations = {
		lap = mkSystem {
			hostName = "lap";
			extraModules = [
				inputs.mango.nixosModules.mango
				agenix.nixosModules.default
				{home-manager.users.${username}.imports = [
					inputs.mango.hmModules.mango
					# inputs.catppuccin.homeModules.catppuccin
				];}
			];
		};

		pc = mkSystem {
			hostName = "pc";
			extraModules = [
				{home-manager.users.${username}.imports = [];}
			];
		};
	};
};

}