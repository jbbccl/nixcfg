{
  config,
  lib,
  ...
}: {
  options.apps.game.enable = lib.mkEnableOption "gaming";

  imports = [
    ./steam.nix
    ./wine.nix
    ./misc.nix
    # ./denuvo/__denuvo__.nix
  ];
}
