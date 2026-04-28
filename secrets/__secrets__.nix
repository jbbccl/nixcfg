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

	config = lib.mkMerge [
		(lib.mkIf config.secrets.available {
			sops.defaultSopsFile = ./secrets.yaml;
			sops.age.keyFile = ageKeyFile;
		})
		(lib.mkIf (!config.secrets.available) {
			warnings = [ "sops 密钥文件 (${ageKeyFile}) 不存在，加密服务已禁用" ];
		})

		({environment.systemPackages = [
			(pkgs.writeShellScriptBin "sops" ''
				export SOPS_EDITOR="vim --clean"
				exec ${pkgs.sops}/bin/sops "$@"
			'')
			pkgs.age
		];})
	];
}
