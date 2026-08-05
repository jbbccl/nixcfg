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
    system = "x86_64-linux";

    sharedModules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.noctalia-greeter.nixosModules.default
      inputs.hermes-agent.nixosModules.default
      inputs.mango.nixosModules.mango
      inputs.stylix.nixosModules.stylix
      ({username, ...}: {
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
      })
    ];

    mkSystem = hostName: modules:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self inputs hostName;};
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
