{ config, lib, pkgs, ... }:
let
	cfg = config.modules.services.audio;
in
{
	options.modules.services.audio = {
		enable = lib.mkEnableOption "audio (pipewire)";
		bluetooth = lib.mkEnableOption "bluetooth support";
	};

	config = lib.mkIf cfg.enable (lib.mkMerge [
		{
			services.pulseaudio.enable = false;
			security.rtkit.enable = true;

			services.pipewire = {
				enable = true;
				alsa.enable = true;
				alsa.support32Bit = true;
				pulse.enable = true;
				wireplumber.enable = true;
			};
		}

		(lib.mkIf cfg.bluetooth {
			services.pipewire.wireplumber.extraConfig."10-bluez" = {
				"monitor.bluez.properties" = {
					"bluez5.enable-sbc-xq" = true;
					"bluez5.enable-msbc" = true;
					"bluez5.enable-hw-volume" = true;
					"bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" "a2dp_sink" "a2dp_source" ];
				};
			};

			hardware.bluetooth = {
				enable = true;
				powerOnBoot = true;
				settings = {
					General = {
						Enable = "Source,Sink,Media,Socket";
						Experimental = true;
						FastConnectable = true;
						Privacy = "device";
					};
				};
			};

			environment.systemPackages = with pkgs; [ overskride ];
		})
	]);
}
