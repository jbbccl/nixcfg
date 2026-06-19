{
  self,
  username,
  config,
  lib,
  ...
}: {
  options.modules.services.ssh.enable = lib.mkEnableOption "ssh (github key)";

  config = lib.mkIf config.modules.services.ssh.enable {
    sops.secrets.github = {
      sopsFile = "${self}/secrets/ssh_keys.yaml";
      mode = "0600";
      owner = "${username}";
      group = "users";
    };

    home-manager.users.${username}.home.file.".ssh/config" = {
      text = ''
        Host github.com
            HostName github.com
            User git
            IdentityFile ${config.sops.secrets.github.path}
            IdentitiesOnly yes
      '';
    };
  };
}
