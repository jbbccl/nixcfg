{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.utilities.basic-tools.enable = lib.mkEnableOption "basic CLI tools";

  config = lib.mkIf config.modules.utilities.basic-tools.enable {
    programs.firejail.enable = true;

    environment.systemPackages = with pkgs; [
      glib
      wget
      curl
      pciutils
      vim
      file
    ];
  };
}
