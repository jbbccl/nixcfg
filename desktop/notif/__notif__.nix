{
  config,
  lib,
  ...
}: let
  mkNotifEnable = name: lib.mkDefault (config.desktop.notif.select == name);
in {
  imports = [
    ./mako/mako.nix
    ./swaync/swaync.nix
  ];

  options.desktop.notif.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum ["mako" "swaync"]);
    default = null;
    description = "notification daemon";
  };

  config = lib.mkIf (config.desktop.notif.select != null) {
    desktop.notif.mako.enable = mkNotifEnable "mako";
    desktop.notif.swaync.enable = mkNotifEnable "swaync";
  };
}
