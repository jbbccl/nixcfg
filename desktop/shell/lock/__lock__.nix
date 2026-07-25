{
  config,
  lib,
  ...
}: {
  options.desktop.shell.lock.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum ["swaylock"]);
    default = null;
    description = "lock screen";
  };

  imports = [
    ./swaylock/swaylock.nix
  ];

  config = lib.mkIf (config.desktop.shell.lock.select != null) {
    desktop.shell.lock.swaylock.enable = lib.mkDefault (config.desktop.shell.lock.select == "swaylock");
  };
}
