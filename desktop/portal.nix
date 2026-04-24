{ pkgs, ... }: {
  # Common XDG Desktop Portal base config.
  # WM-specific portal configs are in each WM module (gated by mkIf).
  xdg.portal = {
    enable = true;
    wlr.enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal-hyprland
    ];
  };
}
