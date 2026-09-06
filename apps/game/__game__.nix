{
  config,
  lib,
  ...
}: {
  imports = [
    ./steam.nix
    ./wine.nix
    ./linuwowo.nix
    ./misc.nix
  ];
}
