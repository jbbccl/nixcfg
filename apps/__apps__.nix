{ config, lib, helpers, ... }:
let
	inherit (helpers) mkNullOrEnum mkNullOrListEnum;
in {
	options.apps.services = {
		ai.enable          = lib.mkEnableOption "AI services (litellm, hermes, opencode)";
		proxy.enable       = lib.mkEnableOption "proxy service (mihomo)";
		ingress.enable     = lib.mkEnableOption "ingress services (cloudflared tunnel + nginx)";
		remote-ctrl.enable = lib.mkEnableOption "remote control services (vnc, nginx basic auth)";
	};

	imports = [
		./services/__services__.nix
		./toolkits/__toolkits__.nix
		./containers/__containers__.nix
		./game/__game__.nix
	];

	config = lib.mkDefault {
		apps.services.ai.enable          = true;
		apps.services.proxy.enable       = true;
		apps.services.ingress.enable     = true;
		apps.services.remote-ctrl.enable = false;
	};
}
