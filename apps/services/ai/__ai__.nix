{ lib, config, username, self, ... }: {
  imports = [
    ./litellm/litellm.nix
    ./hermes/hermes.nix
    ./opencode/opencode.nix
  ];

  config = lib.mkIf (config.apps.services.ai.enable && config.secrets.available) {
    sops.secrets.api-key-env = {
      sopsFile = "${self}/secrets/api_keys.yaml";
      owner = "${username}";
      group = "users";
      mode = "0400";
    };
  };
}
