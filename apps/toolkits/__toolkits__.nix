{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./git.nix
    ./neovim.nix
    ./yazi/yazi.nix
    ./misc.nix
    ./vm-managers.nix
    ./mcu.nix
    ./rs.nix
    ./fpga.nix
  ];
}
