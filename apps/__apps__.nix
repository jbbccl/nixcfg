{ lib, ... }:
let
  inherit (import ../lib/helpers.nix { inherit lib; }) mkEnabledOption;
in lib.mkMerge [
  (mkEnabledOption "apps.services" "application services (AI, proxy, remote)")
  (mkEnabledOption "apps.gui" "GUI applications (terminal, browser, file manager)")
  (mkEnabledOption "apps.cli" "CLI applications (misc tools)")
  {
    imports = [
      ./services/__services__.nix
      ./gui/__gui__.nix
      ./cli/__cli__.nix
    ];
  }
]
