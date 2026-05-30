{ pkgs, unstable, ... }:

{
  programs.niri = {
    enable = true;
    package = unstable.niri;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
    config = {
      niri = {
        default = [ "gnome" "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
      common = {
        default = [ "gtk" ];
      };
    };
  };
}
