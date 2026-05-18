{ config, pkgs, lib, ... }:
let
  xterm = pkgs.writeShellScriptBin "xterm" ''
    exec ${pkgs.kitty}/bin/kitty "$@"
  '';
in {
  imports = [
    ./kitty.nix
    ./alacritty.nix
  ];

  options.desktop.term.select = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum [ "kitty" "alacritty" ]);
    default = null;
    description = "terminal emulator";
  };

  config = lib.mkIf (config.desktop.term.select == "kitty") {
    environment.systemPackages = [ xterm ];
  };
}
