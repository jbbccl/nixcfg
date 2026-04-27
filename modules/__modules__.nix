{ lib, ... }:
let
  inherit (import ../lib/helpers.nix { inherit lib; }) mkEnabledOption;
in lib.mkMerge [
  (mkEnabledOption "modules.services" "system services (audio, networking, ssh)")
  (mkEnabledOption "modules.development" "development tooling (git, languages)")
  (mkEnabledOption "modules.shells" "shell configurations (zsh, fish, bash)")
  (mkEnabledOption "modules.virtualization" "virtualization (KVM, containers, appimage)")
  (mkEnabledOption "modules.utilities" "utilities (neovim, yazi, basic tools)")
  {
    imports = [
      ./development/__development__.nix
      ./services/__services__.nix
      ./shells/__shells__.nix
      ./virtual/__virtual__.nix
      ./utilities/__utilities__.nix
    ];
  }
]
