{
  config,
  lib,
  ...
}: let
  cfg = config.apps.services.proxy;
in {
  options.apps.services.proxy.enable = lib.mkEnableOption "proxy service (mihomo)";

  imports = [
    ./mihomo/__mihomo__.nix
    ./dae/daed.nix
    ./dae/dae.nix
  ];

  config = lib.mkIf cfg.enable {
    programs.fish.shellInit = builtins.readFile ./proxy.fish;
    programs.zsh.shellInit = builtins.readFile ./proxy.sh;
  };
}
