{ pkgs, ... }:

{

environment.systemPackages = with pkgs; [
	java
];


}
