{
  config,
  lib,
  ...
}: let
  mkNotifEnable = name: lib.mkDefault (config.desktop.shell.notif.select == name);
in {
  imports = [
    ./mako/mako.nix
    ./swaync/swaync.nix
  ];

  options.desktop.shell.notif.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum ["mako" "swaync"]);
    default = null;
    description = "notification daemon";
  };

  config = lib.mkIf (config.desktop.shell.notif.select != null) {
    desktop.shell.notif.mako.enable = mkNotifEnable "mako";
    desktop.shell.notif.swaync.enable = mkNotifEnable "swaync";
  };
}
