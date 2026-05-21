{ config, lib, pkgs, ... }:
let
cfg = config.modules.services.kmscon;
in
{
	options.modules.services.kmscon.enable = lib.mkEnableOption "kmscon";

	config = lib.mkIf cfg.enable {		
		services.kmscon = {
			enable = true;
			hwRender = true;
			fonts = [{
				name = "Maple Mono NF CN";
				package = pkgs.maple-mono.NF-CN;
			}];
			extraConfig = "font-size=22";
		};
	};
}