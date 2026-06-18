{ config, lib, ... }:
{
  options.apps.enable = lib.mkEnableOption "applications";

  imports = [
    ./services/__services__.nix
    ./toolkits/__toolkits__.nix
    # ./containers/__containers__.nix
    ./game/__game__.nix
  ];

  config = lib.mkMerge [
    { apps.enable = lib.mkDefault true; }
    (lib.mkIf config.apps.enable {
      apps = lib.mkDefault {
        services.ai.enable          = true;
        services.ai.hermes.enable   = true;
        services.ai.litellm.enable  = true;
        services.ai.opencode.enable = true;
        services.proxy.enable       = true;
        services.proxy.mihomo.enable = true;
        # services.proxy.daed.enable = true;# TODO WPI
        # services.proxy.dae.enable  = true;
        services.ingress.enable     = false;
        services.remote-ctrl.enable = false;
        toolkits.enable             = true;
        toolkits.editors.enable     = true;
        game.enable                 = true;
        game.steam.enable           = true;
      };
    })
  ];
}
