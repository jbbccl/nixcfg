# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{...}: {
  imports = [
    ./hardware-configuration.nix
    ./driver.nix
    ./boot.nix
    ../common.nix
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  apps.game.steam.enable = false;
}
