{
  username,
  pkgs,
  lib,
  self,
  ...
}: let
  ageKeyFile = "/root/.config/sops/age/keys.txt";
  hasKey = true; # builtins.pathExists ageKeyFile;
in {
  options.secrets.path = lib.mkOption {
    type = lib.types.path;
    default = "${self}/secrets";
    description = "sops secrets directory, override per host to avoid key conflicts";
  };

  config = lib.mkMerge [
    {
      sops = lib.mkIf hasKey {
        age.keyFile = ageKeyFile;
      };
      environment.systemPackages = [pkgs.sops pkgs.age];
      environment.sessionVariables.SOPS_EDITOR = "vim --clean";
    }
  ];
}
