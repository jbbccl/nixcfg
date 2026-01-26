# ！sudo会重置环境变量, 导致不走代理, 第一次构建使用sudo -E
# sudo nixos-rebuild switch --flake ~/nixrc#lap
# 使用缓存
# sudo nixos-rebuild switch --flake ~/nixrc#lap --option substituters ""
# 使用官方源sudo NIX_CONFIG="substituters = https://cache.nixos.org" nixos-..
# sudo nixos-rebuild switch --flake ~/nixrc#lap --option substituters "https://cache.nixos.org"
# 测试
# nix flake check ~/nixrc
# 更新
# nix flake update
# 清理
# sudo nix-collect-garbage -d
{
inputs = {
	nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
	nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
	nixpkgs-master.url = "github:NixOS/nixpkgs/master";

	nixpkgs.follows = "nixpkgs-unstable";

	noctalia = {
		url = "github:noctalia-dev/noctalia-shell";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};
};

outputs = inputs@{ 
	self,
	nixpkgs,
	home-manager,
	... }: {
nixosConfigurations.lap = nixpkgs.lib.nixosSystem {
system = "x86_64-linux";
modules = [
	./host/lap/configuration.nix
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
	home-manager.nixosModules.home-manager
];
specialArgs = {
	username = "e";
	inherit self inputs;
	};
};
# 可以定义多个配置
#     nixosConfigurations.my-laptop = nixpkgs.lib.nixosSystem {
#       system = "x86_64-linux";
#       modules = [ ... ];
#     };
};
}
