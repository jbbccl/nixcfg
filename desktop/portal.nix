{ pkgs, ... }: {
  # Common XDG Desktop Portal base: only GTK as universal fallback.
  # WM-specific portals (wlr, gnome, hyprland) are added by each WM module.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
