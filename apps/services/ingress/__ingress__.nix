{ lib, config, self, ... }: {
  imports = [
    ./nginx.nix
    ./cloudflared.nix
  ];

  sops.secrets = lib.mkIf config.secrets.available {
    cloudflared-sh-tunnel = {
      sopsFile = "${self}/secrets/token.yaml";
    };
  };
}
