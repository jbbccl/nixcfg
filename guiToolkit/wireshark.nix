{ config, pkgs, username, ... }: {
    programs.wireshark.enable = true;

    programs.wireshark.package = pkgs.wireshark;

    users.users.${username}.extraGroups = [ "wireshark" ];
}
