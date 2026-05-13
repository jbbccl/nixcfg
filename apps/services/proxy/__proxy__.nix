{ self, config, pkgs, lib, ... }:
let
  template = builtins.readFile ./mihomo/config.yaml;
in
lib.mkIf (config.apps.services.proxy.enable && config.secrets.available) {
  sops.secrets = {
    airport01URL = { sopsFile = "${self}/secrets/token.yaml"; };
    airport02URL = { sopsFile = "${self}/secrets/token.yaml"; };
    airport03URL = { sopsFile = "${self}/secrets/token.yaml"; };
  };

  services.mihomo = {
    enable = true;
    configFile = config.sops.templates."mihomo-config.yaml".path;
    webui = pkgs.metacubexd;
    tunMode = true;
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
}
