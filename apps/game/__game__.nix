{
  config,
  lib,
  ...
}: {
  options.apps.game.enable = lib.mkEnableOption "gaming";

  imports = [
    ./steam.nix
  ];
}
