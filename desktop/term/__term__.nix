{ config, pkgs, lib, helpers, ... }:
let
  inherit (helpers) mkNullOrEnum;
  xterm = pkgs.writeShellScriptBin "xterm" ''
    exec ${pkgs.kitty}/bin/kitty "$@"
  '';
in {
  imports = [
    ./kitty.nix
    ./alacritty.nix
  ];

  options.desktop.term.select = mkNullOrEnum "terminal emulator" [ "kitty" "alacritty" ];

  config = lib.mkIf (config.desktop.term.select == "kitty") {
    environment.systemPackages = [ xterm ];
  };
}
