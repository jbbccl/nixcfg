{ username, pkgs, lib, config, ... }:
let
	ageKeyFile = "/root/.config/sops/age/keys.txt";
	hasKey = true;
in
{
	options.secrets.available = lib.mkOption {
		type = lib.types.bool;
		default = hasKey;
		description = "是否启用需要 sops 密钥的服务";
	};

	# config.secrets.available 是整个 config 块的开关
	config = lib.mkMerge [
		(lib.mkIf config.secrets.available {
			sops.defaultSopsFile = ./secrets.yaml;
			sops.age.keyFile = ageKeyFile;

			sops.secrets = {
				# apps/services/proxy
				airport01URL = { sopsFile = ./token.yaml; };
				airport02URL = { sopsFile = ./token.yaml; };
				airport03URL = { sopsFile = ./token.yaml; };

				# apps/services/ai/litellm
				api-key-env = {
					sopsFile = ./api_keys.yaml;
					owner = "${username}";
					group = "users";
					mode = "0400";
				};
				hermes-env = {
					sopsFile = ./api_keys.yaml;
					owner = "${username}";
					group = "hermes";
					mode = "0400";
				};

				# modules/services/ssh.nix
				github = {
					sopsFile = ./ssh_keys.yaml;
					mode = "0600";
					owner = "${username}";
					group = "users";
				};

				# laterTODO apps/services/remote-ctrl/nginx.nix — basic auth password hash
				# nginx-basic-auth-hash = {
				# 	sopsFile = ./token.yaml;
				# 	mode = "0400";
				# 	owner = "nginx";
				# 	group = "nginx";
				# };
			};

			environment.systemPackages = [
				(pkgs.writeShellScriptBin "sops" ''
					export SOPS_EDITOR="vim --clean"
					exec ${pkgs.sops}/bin/sops "$@"
				'')
				pkgs.age
			];
		})
		(lib.mkIf (!config.secrets.available) {
			warnings = [ "sops 密钥文件 (${ageKeyFile}) 不存在，加密服务已禁用" ];
		})
	];
}
