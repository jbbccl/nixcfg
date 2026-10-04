{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.services.ai.dsh;
  # 从 GitHub 源码构建 (见 dsh-package.nix), 不引用任何本地 checkout
  dsh = pkgs.callPackage ./dsh-package.nix {};
  dshWrapped = pkgs.writeShellScriptBin "dsh" ''
    set -a
    # shellcheck disable=SC1091
    if [ -f "${config.sops.secrets.api-key-env.path}" ]; then
      source "${config.sops.secrets.api-key-env.path}"
    fi
    set +a
    exec ${lib.getExe dsh} "$@"
  '';
in {
  options.apps.services.ai.dsh.enable = lib.mkEnableOption "DeepSeek Harness (dsh) CLI";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      dshWrapped
    ];
  };
}
