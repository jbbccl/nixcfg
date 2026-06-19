{
  lib,
  config,
  username,
  self,
  ...
}: let
  cfg = config.apps.services.ai;
in {
  options.apps.services.ai.enable = lib.mkEnableOption "AI services (litellm, hermes, opencode)";

  imports = [
    ./litellm/litellm.nix
    ./hermes/hermes.nix
    ./opencode/opencode.nix
  ];

  config = lib.mkIf cfg.enable {
    sops.secrets.api-key-env = {
      sopsFile = "${self}/secrets/api_keys.yaml";
      owner = "${username}";
      group = "users";
      mode = "0400";
    };
  };
}
