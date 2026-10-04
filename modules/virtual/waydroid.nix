{
  config,
  lib,
  ...
}: let
  cfg = config.modules.virtual.waydroid;
in {
  options.modules.virtual.waydroid.enable = lib.mkEnableOption "waydroid (Android container)";

  config = lib.mkIf cfg.enable {
    virtualisation.waydroid.enable = true;

    systemd.services.waydroid-container.wantedBy = lib.mkForce [];

    networking.firewall.trustedInterfaces = ["waydroid0"];
  };
}
