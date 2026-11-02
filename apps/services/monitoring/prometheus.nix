{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.services.monitoring.prometheus;
in {
  options.apps.services.monitoring.prometheus = {
    enable = lib.mkEnableOption "kube-prometheus-stack inside k3s";

    namespace = lib.mkOption {
      type = lib.types.str;
      default = "monitoring";
      description = "Kubernetes namespace for the Prometheus stack.";
    };
  };

  config = lib.mkIf (cfg.enable && config.apps.services.monitoring.k3s.enable) {
    systemd.services.kube-prometheus-stack = {
      description = "Deploy kube-prometheus-stack into k3s";
      wants = ["network-online.target"];
      requires = ["k3s.service"];
      after = ["k3s.service" "network-online.target"];
      wantedBy = ["multi-user.target"];
      path = [pkgs.kubernetes-helm pkgs.kubectl];
      environment = {
        HOME = "/root";
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      };
      script = ''
        set -eu
        # 等 k3s API 就绪
        for _ in $(seq 60); do
          kubectl get nodes >/dev/null 2>&1 && break
          sleep 2
        done
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts --force-update
        helm repo update
        helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
          --namespace ${cfg.namespace} --create-namespace \
          --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
          --wait --timeout 15m
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
