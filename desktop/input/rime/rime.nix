{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.desktop.input.rime;
  rime-ice = pkgs.callPackage ./rime-ice.nix {};
  rime-data = pkgs.runCommand "rime-data" {} ''
    mkdir -p $out
    cp -r ${rime-ice}/share/rime-data/* $out/
    cp ${./share}/* $out/
  '';
in {
  options.desktop.input.rime = {
    enable = lib.mkEnableOption "rime-ice";
    shareDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/${username}/.local/share/rime";
      description = "共享 rime 数据目录 (在 ~/.local/share/ 下)";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [rime-ice];
    home-manager.users.${username}.home.file.${cfg.shareDir} = {
      source = rime-data;
      force = true;
      recursive = true;
    };
  };
}
