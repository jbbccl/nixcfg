{
  config,
  pkgs,
  username,
  lib,
  ...
}: let
  cfg = config.apps.toolkits.wireshark;
in {
  options.apps.toolkits.wireshark.enable = lib.mkEnableOption "wireshark";

  config = lib.mkIf cfg.enable {
    programs.wireshark.enable = true;

    programs.wireshark.package = pkgs.wireshark;

    users.users.${username}.extraGroups = ["wireshark"];
  };
}
