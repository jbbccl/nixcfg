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

		pkgs = import nixpkgs { inherit system; };
		flakeSrc = self;

		mkSystem = { hostName, extraModules ? [] }: nixpkgs.lib.nixosSystem {
			inherit system;

			specialArgs = {
				inherit self inputs username hostName;
				helpers = lib.helpers;
				validators = lib.validators;
			};

			modules = [
				./host/${hostName}/configuration.nix
				home-manager.nixosModules.home-manager
				{ nixpkgs.overlays = lib.nixpkgsOverlays; }
			] ++ [
				sops-nix.nixosModules.sops
				hermes-agent.nixosModules.default
				inputs.mango.nixosModules.mango
				{
					home-manager.users.${username} = {
						imports = [
							inputs.mango.hmModules.mango
						];
					};
				}
			] ++ extraModules;
		};
	in
	{
		# ── NixOS configurations ────────────────────────────────────
		nixosConfigurations = {
			lap = mkSystem {
				hostName = "lap";
				extraModules = [
					{home-manager.users.${username}.imports = [
					];}
				];
			};

			pc = mkSystem {
				hostName = "pc";
				extraModules = [
					{home-manager.users.${username}.imports = [
					];}
				];
			};
		};
	};
}
