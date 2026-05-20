{ self, config, pkgs, lib, ... }:
let
  template = builtins.readFile ./config.yaml;
  geodata = pkgs.callPackage ./geodata.nix { };
in
lib.mkIf (config.apps.services.proxy.enable && config.secrets.available) {
  sops.secrets = {
    airport01URL = { sopsFile = "${self}/secrets/token.yaml"; };
    airport02URL = { sopsFile = "${self}/secrets/token.yaml"; };
    airport03URL = { sopsFile = "${self}/secrets/token.yaml"; };
  };

  sops.templates."mihomo-config.yaml" = {
    owner = "root";
    group = "root";
    mode = "640";
    content = lib.replaceStrings [
      "AIRPORT01_URL_PLACEHOLDER"
      "AIRPORT02_URL_PLACEHOLDER"
      "AIRPORT03_URL_PLACEHOLDER"
    ] [
      config.sops.placeholder.airport01URL
      config.sops.placeholder.airport02URL
      config.sops.placeholder.airport03URL
    ] (template);
  };

  services.mihomo = {
    enable = true;
    configFile = config.sops.templates."mihomo-config.yaml".path;
    webui = pkgs.metacubexd;
    tunMode = true;
  };

  systemd.services.mihomo.serviceConfig.BindReadOnlyPaths = [
    "${geodata}/GeoSite.dat:/var/lib/private/mihomo/GeoSite.dat"
    "${geodata}/GeoIP.dat:/var/lib/private/mihomo/GeoIP.dat"
  ];
  
}
