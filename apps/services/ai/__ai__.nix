{
  lib,
  config,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.services.ai;
  # 注入 api-key-env 后进入当前登录壳 (fish/zsh/...)
  aiShell = pkgs.writeShellScriptBin "ai-shell" ''
    set -euo pipefail
    set -a
    # shellcheck disable=SC1091
    source ${config.sops.secrets.api-key-env.path}
    set +a
    shell="''${SHELL:-${pkgs.fish}/bin/fish}"
    case "''${1:-}" in
      fish|zsh|bash)
        shell="$1"
        shift
        ;;
    esac
    case "$(basename "$shell")" in
      fish) exec ${pkgs.fish}/bin/fish -l "$@" ;;
      zsh)  exec ${pkgs.zsh}/bin/zsh -l "$@" ;;
      bash) exec ${pkgs.bashInteractive}/bin/bash -l "$@" ;;
      *)    exec "$shell" "$@" ;;
    esac
  '';
in {
  options.apps.services.ai.enable = lib.mkEnableOption "AI services (litellm, hermes, opencode)";

  imports = [
    ./litellm/litellm.nix
    ./hermes/hermes.nix
    ./opencode/opencode.nix
    ./pi/pi.nix
  ];

  config = lib.mkIf cfg.enable {
    sops.secrets.api-key-env = {
      sopsFile = config.secrets.path + "/api_keys.yaml";
      owner = "${username}";
      group = "users";
      mode = "0400";
    };

    environment.systemPackages = [aiShell];
  };
}
