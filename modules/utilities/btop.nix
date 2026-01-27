{ pkgs, ... }: {
environment.systemPackages = with pkgs; [btop];
# catppuccin.btop = {
# 	enable = true;
# 	flavor = "macchiato";
# };
}
