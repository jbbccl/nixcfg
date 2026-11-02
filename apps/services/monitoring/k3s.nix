{
  config,
  lib,
  ...
}: let
  cfg = config.apps.services.monitoring.k3s;
in {
  options.apps.services.monitoring.k3s.enable = lib.mkEnableOption "single-node k3s server";

  config = lib.mkIf cfg.enable {
    services.k3s = {
      enable = true;
      role = "server";
      # 让普通用户也能直接用 kubectl / helm
      extraFlags = ["--write-kubeconfig-mode=644"];
    };
  };
}
