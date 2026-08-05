# lib/install-iso.nix — offline installer ISO with full desktop
#
# Build: nix build .#nixosConfigurations.install-iso.config.system.build.isoImage
# 安装步骤: ISO 内 /etc/nixos/INSTALL.txt
{
  self,
  inputs,
  system,
}: let
  username = "e";
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit self inputs;
      username = username;
      hostName = "iso-installer";
    };
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
      ../core/__core__.nix

      ../secrets/__secrets__.nix

      ../modules/shells/__shells__.nix

      ../desktop/__desktop__.nix

      ../apps/cli/__cli__.nix
      ../apps/services/ai/__ai__.nix

      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.hermes-agent.nixosModules.default
      inputs.mango.nixosModules.mango
      inputs.stylix.nixosModules.stylix
      inputs.noctalia-greeter.nixosModules.default
      ({
        config,
        pkgs,
        lib,
        ...
      }: {
        system.stateVersion = "25.11";
        nixpkgs.overlays = import ./overlays.nix {inherit inputs system;};
        nixpkgs.config.allowUnfree = true;
        

        home-manager= {
          startAsUserService = false;
          backupFileExtension = "backup";
          users.${username}.home.stateVersion = "26.05";
        };

        users.users.${username}.initialPassword = lib.mkForce "pass";

        modules.shells.enable = true;
        modules.shells.fish.enable = true;

        desktop.browser.firefox.enable = false;

        apps.services.ai.enable = true;
        apps.services.ai.opencode.enable = true;

        environment.systemPackages = with pkgs; [
          kdePackages.partitionmanager
          flclash
        ];

        environment.etc."nixos/flake".source = self;
        environment.etc."nixos/INSTALL.txt".text = ''
          mount /dev/xx /mnt
          cp -r /etc/nixos/flake /mnt/etc/nixos
          nixos-generate-config --root /mnt
          cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/host/lap/
          nixos-install --no-root-passwd --flake /mnt/etc/nixos#lap --root /mnt
        '';
      })
    ];
  }
