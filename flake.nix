# sudo nixos-rebuild switch --flake ~/nixcfg#lap
# nix flake check ~/nixcfg
# nix flake update
# nix flake lock --update-input noctalia
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

		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		hermes-agent = {
			url = "github:NousResearch/hermes-agent";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nixpkgs, home-manager, sops-nix, hermes-agent, ... }:
	let
		username = "e";
		system = "x86_64-linux";

		lib = import ./lib { inherit inputs system; };

		mkSystem = { hostName, extraModules ? [] }: nixpkgs.lib.nixosSystem {
			inherit system;

			specialArgs = {
				inherit self inputs username hostName;
			};

			modules = [
				./host/${hostName}/configuration.nix

				sops-nix.nixosModules.sops
				hermes-agent.nixosModules.default
				
				home-manager.nixosModules.home-manager
				{ nixpkgs.overlays = lib.nixpkgsOverlays; }
				{
					home-manager.users.${username} = {
						imports = [];
					};
				}
			] ++ extraModules;
		};
	in
	{
		formatter.x86_64-linux = (import nixpkgs { system = "x86_64-linux"; }).nixpkgs-fmt;

		nixosConfigurations = {
			lap = mkSystem {
				hostName = "lap";
				extraModules = [
					inputs.mango.nixosModules.mango
					{home-manager.users.${username}.imports = [
						inputs.mango.hmModules.mango
					];}
				];
			};

			pc = mkSystem {
				hostName = "pc";
				extraModules = [
					inputs.mango.nixosModules.mango
					{home-manager.users.${username}.imports = [
						inputs.mango.hmModules.mango
					];}
				];
			};
		};
	};
}
