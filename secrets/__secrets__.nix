{ username, pkgs, lib, ... }:
let
	ageKeyFile = "/root/.config/sops/age/keys.txt";
	hasKey = true; # builtins.pathExists ageKeyFile;
in
{
	config = lib.mkMerge [
		{
			sops = lib.mkIf hasKey {
				defaultSopsFile = ./secrets.yaml;
				age.keyFile = ageKeyFile;
			};
			environment.systemPackages = [
				(pkgs.writeShellScriptBin "sops" ''
					export SOPS_EDITOR="vim --clean"
					exec ${pkgs.sops}/bin/sops "$@"
				'')
				pkgs.age
			];
		}
		(lib.mkIf (!hasKey) {
			warnings = [ "sops 密钥文件 (${ageKeyFile}) 不存在，依赖加密的服务已强制关闭" ];
			apps.services.ai.enable           = lib.mkForce false;
			apps.services.proxy.mihomo.enable = lib.mkForce false;
			apps.services.proxy.dae.enable    = lib.mkForce false;
			apps.services.ingress.enable      = lib.mkForce false;
			apps.services.remote-ctrl.enable  = lib.mkForce false;
			modules.services.ssh.enable       = lib.mkForce false;
		})
	];
}
