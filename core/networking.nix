{
  username,
  hostName,
  ...
}: {
  networking = {
    inherit hostName;
    networkmanager.enable = true;
    # networkmanager.wifi.backend = "iwd";
    nftables.enable = true;
    firewall.enable = true;
  };
  users.users.${username}.extraGroups = ["networkmanager"];

  systemd.services.NetworkManager-wait-online.environment.NM_ONLINE_TIMEOUT = "10";

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
  };
}
