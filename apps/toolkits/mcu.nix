{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.toolkits.mcu;
in {
  options.apps.toolkits.mcu.enable = lib.mkEnableOption "MCU toolchains (sdcc, platformio)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sdcc
      platformio
    ];

    environment.sessionVariables = {
      SDCC_HOME = "${pkgs.sdcc}";
      SDCC_INCLUDE = "${pkgs.sdcc}/share/sdcc/include";
    };

    users.users.${username}.extraGroups = ["dialout"];
  };
}
