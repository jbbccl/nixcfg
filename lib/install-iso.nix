# lib/install-iso.nix — offline installer ISO with full desktop
#
# Build: nix build .#nixosConfigurations.install-iso.config.system.build.isoImage
# Usage: dd to USB → boot → tuigreet login → niri → partitionmanager → install
{
  self,
  inputs,
  system,
  cfgLib,
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
      ../core/console.nix
      ../core/user.nix
      ../core/networking.nix

      ../modules/shells/__shells__.nix

      ../desktop/__desktop__.nix

      ../apps/toolkits/editors.nix
      ../apps/services/proxy/__proxy__.nix
      ../apps/services/ai/__ai__.nix

      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.hermes-agent.nixosModules.default
      inputs.mango.nixosModules.mango
      inputs.stylix.nixosModules.stylix
      inputs.noctalia.nixosModules.default
      inputs.noctalia-greeter.nixosModules.default
      ({
        config,
        pkgs,
        lib,
        ...
      }: {
        nixpkgs.overlays = cfgLib.nixpkgsOverlays;
        system.stateVersion = "25.11";

        users.users.${username}.initialPassword = lib.mkForce "nixos";

        apps.toolkits.editors.enable = true;
        apps.services.proxy.enable = true;
        apps.services.ai.enable = true;
        apps.services.ai.hermes.enable = lib.mkForce false;
        apps.services.ai.litellm.enable = lib.mkForce false;
        apps.services.ai.pi.enable = lib.mkForce false;
        apps.services.ai.opencode.enable = true;
        modules.shells.enable = true;
        modules.shells.fish.enable = true;

        # system-level: activates hm at boot, before user sessions start
        # ensures ~/.config/environment.d/ exists when systemd --user reads it
        home-manager.startAsUserService = false;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${username}.home.stateVersion = "26.05";

        environment.systemPackages = [
          pkgs.kdePackages.partitionmanager
        ];

        environment.etc."nixos/flake".source = self;
        environment.etc."TEST".text = ''
          mount /dev/xx /mnt
          cp -r /etc/nixos/flake /mnt/etc/nixos
          nixos-generate-config --root /mnt
          cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/host/lap/
          nixos-install --no-root-passwd --flake /mnt/etc/nixos#lap --root /mnt
        '';
      })
    ];
  }
