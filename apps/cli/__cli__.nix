{
  config,
  lib,
  ...
}: {
  options.apps.cli.enable = lib.mkEnableOption "CLI applications";

  imports = [
    ./git.nix
    ./neovim.nix
    ./yazi/yazi.nix
  ];

  config = lib.mkMerge [
    {apps.cli.enable = lib.mkDefault true;}
    (lib.mkIf config.apps.cli.enable {
      apps.cli = lib.mkDefault {
        git.enable = true;
        neovim.enable = true;
        yazi.enable = true;
      };
    })
  ];
}
