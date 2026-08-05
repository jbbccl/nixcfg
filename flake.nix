{
  description = "Optimized NixOS Flake Configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs.follows = "nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
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

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    username = "e";
    system = "x86_64-linux";

    # 所有主机共享: flake 模块 + 基础默认值
    # 主机间有意差异 (如 install-iso 的 home-manager.startAsUserService=false) 写在各自 host 文件
    sharedModules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.noctalia-greeter.nixosModules.default
      inputs.hermes-agent.nixosModules.default
      inputs.mango.nixosModules.mango
      inputs.stylix.nixosModules.stylix
      {
        system.stateVersion = "25.11";
        # pkgs.stable (26.05) 与默认 unstable 并存
        nixpkgs.overlays = [
          (final: prev: {
            stable = import inputs.nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
        home-manager.backupFileExtension = "backup";
        home-manager.startAsUserService = nixpkgs.lib.mkDefault true;
        home-manager.users.${username}.home.stateVersion = "26.05";
      }
    ];

    mkSystem = hostName: modules:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self inputs username hostName;};
        modules = sharedModules ++ modules;
      };
  in {
    nixosConfigurations = {
      lap = mkSystem "lap" [./host/lap/configuration.nix];
      pc = mkSystem "pc" [./host/pc/configuration.nix];
      install-iso = mkSystem "iso-installer" [./host/install-iso/configuration.nix];
    };
  };
}
