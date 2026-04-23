{ pkgs, config, lib, username, ... }:
let
	configFile = builtins.toFile "litellm-config.yaml" (builtins.readFile ./config.yaml);
in
{
	environment.systemPackages = [
		pkgs.litellm
	];

	# services.litellm = {
	# 	enable = true;
	# 	host = "127.0.0.1";
	# 	port = 4001;

	# 	settings = {
	# 		model_list = [
	# 			{
	# 				model_name = "deepseek-reasoner";
	# 				litellm_params = {
	# 					model = "deepseek/deepseek-reasoner";
	# 					api_key = "os.environ/DEEPSEEK_API_KEY";
	# 					api_base = "https://api.deepseek.com";
	# 				};
	# 			}
	# 			{
	# 				model_name = "deepseek-chat";
	# 				litellm_params = {
	# 					model = "deepseek/deepseek-chat";
	# 					api_key = "os.environ/DEEPSEEK_API_KEY";
	# 					api_base = "https://api.deepseek.com";
	# 				};
	# 			}
	# 			{
	# 				model_name = "minimax-m2.7";
	# 				litellm_params = {
	# 					model = "minimax/MiniMax-M2.5";
	# 					api_key = "os.environ/MINIMAX_API_KEY";
	# 					# api_base = "https://api.minimax.io/v1";
	# 					api_base = "https://api.minimaxi.com/anthropic"; 
	# 				};
	# 			}
	# 		];

	# 		litellm_settings = {
	# 			drop_params = true;
	# 			modify_params = true;
	# 			# set_verbose = true;
	# 		};

	# 		general_settings = {
	# 		# master_key = "os.environ/LITELLM_MASTER_KEY";
	# 		};
	# 	};

	# 	environmentFile = config.sops.secrets.litellm-env.path;

	# 	openFirewall = true;  # 根据需要
	# };
	# systemd.services.litellm.wantedBy = lib.mkForce [ ];


	systemd.user.services.litellm = {
		enable = true;
		description = "LiteLLM Proxy (user mode)";
		after = [ "network.target" ];
		# wantedBy = [ "default.target" ];

		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.litellm}/bin/litellm --host 127.0.0.1 --port 4010 --config ${configFile}" ;
			Restart = "always";
			RestartSec = "5";
			EnvironmentFile = config.sops.secrets.litellm-env.path;
		};
		# environment = {
		# 	LITELLM_MASTER_KEY="sk-1234";
		# };
	};
}