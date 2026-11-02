{
  config,
  lib,
  ...
}: let
  cfg = config.apps.services.monitoring;
in {
  options.apps.services.monitoring.enable = lib.mkEnableOption "k3s + kube-prometheus-stack";

  imports = [
    ./k3s.nix
    ./prometheus.nix
  ];

  config = lib.mkIf cfg.enable {
    apps.services.monitoring.k3s.enable = lib.mkDefault true;
    apps.services.monitoring.prometheus.enable = lib.mkDefault true;
  };
}
