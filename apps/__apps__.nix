{lib, ...}: {
  imports = [
    ./services/__services__.nix
    ./toolkits/__toolkits__.nix
    ./cli/__cli__.nix
    ./game/__game__.nix
  ];

  config.apps = lib.mkDefault {
    services.ai.enable = true;
    services.ai.hermes.enable = true;
    services.ai.litellm.enable = false;
    services.ai.opencode.enable = true;
    services.ai.pi.enable = true;
    services.proxy.enable = true;
    services.proxy.mihomo.enable = true;
    # services.proxy.daed.enable = true;# TODO WPI
    # services.proxy.dae.enable  = true;
    services.ingress.enable = false;
    services.remote-ctrl.enable = false;
    toolkits.enable = true;
    # toolkits.mcu.enable = true;
    # toolkits.fpga.enable = true;
    toolkits.pwndbg.enable = true;
    game.enable = true;
    game.steam.enable = true;
    game.wine.enable = true;
  };
}
