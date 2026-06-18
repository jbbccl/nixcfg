{ pkgs, username, ... }:
let
#   myClashVerge = pkgs.callPackage ./clash-verge/package.nix { };
in
{
	environment.systemPackages = with pkgs; [
        sdcc
	];

    environment.sessionVariables = {
        SDCC_HOME = "${pkgs.sdcc}";
        SDCC_INCLUDE = "${pkgs.sdcc}/share/sdcc/include";
	};

    users.users.${username}.extraGroups = [ "dialout" ];
}
