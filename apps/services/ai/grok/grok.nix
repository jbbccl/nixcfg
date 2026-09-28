{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.services.ai.grok;
  grokWrapped = pkgs.writeShellScriptBin "grok" ''
    set -a
    source ${config.sops.secrets.api-key-env.path}
    set +a
    exec ${pkgs.grok-build}/bin/grok "$@"
  '';
in {
  options.apps.services.ai.grok.enable = lib.mkEnableOption "grok-build (xAI coding agent) CLI";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      grokWrapped
    ];

    home-manager.users.${username} = {
      # grok 运行时会自己改写 config.toml (模型/UI 等状态), 不能用 home.file 托管:
      # 否则下次 rebuild 要备份 live 配置时, config.toml.backup 已存在 → 激活整体失败。
      # 改成"仅首次创建": 文件不存在才写入默认配置, 之后交给 grok 自己维护。
      home.activation.seedGrokConfig = ''
        if [ ! -f "$HOME/.grok/config.toml" ]; then
          mkdir -p "$HOME/.grok"
          install -m 644 ${./config.toml} "$HOME/.grok/config.toml"
        fi
      '';
    };
  };
}
