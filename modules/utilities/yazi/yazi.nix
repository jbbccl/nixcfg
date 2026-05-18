{ lib, pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
    (yazi.override {
      _7zz = _7zz-rar;
    })
  ];
  home-manager.users.${username} = {
    xdg.configFile."yazi/" = {
		force = true;
		recursive = true;
		source = ./config;
	};
  };
}
