{ config, lib, ... }:
{
	options.apps = {
		services.ai.enable          = lib.mkEnableOption "AI services (litellm, hermes, opencode)";
		services.proxy.enable       = lib.mkEnableOption "proxy service (mihomo)";
		services.ingress.enable     = lib.mkEnableOption "ingress services (cloudflared tunnel + nginx)";
		services.remote-ctrl.enable = lib.mkEnableOption "remote control services (vnc, nginx basic auth)";

		game.steam.enable			= lib.mkEnableOption "steam";
	};

	imports = [
		./services/__services__.nix
		./toolkits/__toolkits__.nix
		# ./containers/__containers__.nix
		./game/__game__.nix
	];

	config.apps = lib.mkDefault {
		services.ai.enable          = true;
		services.proxy.enable       = true;
		services.ingress.enable     = false;
		services.remote-ctrl.enable = false;

		game.steam.enable = true;
	};
}
