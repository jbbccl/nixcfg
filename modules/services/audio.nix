{ config, lib, ... }:
{
	options.modules.services.audio.enable = lib.mkEnableOption "audio (pipewire)";

	config = lib.mkIf config.modules.services.audio.enable {
		services.pulseaudio.enable = false;
		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
	};
}
