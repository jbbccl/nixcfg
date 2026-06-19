{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.services.proxy.dae;
  template = builtins.readFile ./config-dae.dae;

  # MetaCubeX geosite.dat — superset of v2ray, includes gfw/category-* etc.
  metacubex-geosite = pkgs.stdenvNoCC.mkDerivation {
    name = "metacubex-geosite";
    src = pkgs.fetchurl {
      url = "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat";
      hash = "sha256-4OVrzZVCOXfFFJheCfStVZ/doEhwHjxtQOdJylUdzH4=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/v2ray
      cp $src $out/share/v2ray/geosite.dat
    '';
  };

  daeAssets = pkgs.symlinkJoin {
    name = "dae-assets";
    paths = with pkgs; [v2ray-geoip metacubex-geosite];
  };
in {
  options.apps.services.proxy.dae.enable = lib.mkEnableOption "dae proxy (pure, no web UI)";

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      airport01URL = {sopsFile = "${self}/secrets/token.yaml";};
      airport02URL = {sopsFile = "${self}/secrets/token.yaml";};
      airport03URL = {sopsFile = "${self}/secrets/token.yaml";};
      airport04URL = {sopsFile = "${self}/secrets/token.yaml";};
    };

    sops.templates."dae-config" = {
      owner = "root";
      group = "root";
      mode = "640";
      content =
        lib.replaceStrings [
          "AIRPORT01_URL_PLACEHOLDER"
          "AIRPORT02_URL_PLACEHOLDER"
          "AIRPORT03_URL_PLACEHOLDER"
          "AIRPORT04_URL_PLACEHOLDER"
        ] [
          config.sops.placeholder.airport01URL
          config.sops.placeholder.airport02URL
          config.sops.placeholder.airport03URL
          config.sops.placeholder.airport04URL
        ]
        template;
    };

    services.dae = {
      enable = true;
      configFile = config.sops.templates."dae-config".path;
      openFirewall.port = 7897;
      assetsPath = "${daeAssets}/share/v2ray";
    };
  };
}
