{ pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = ./050010.yaml;

    fonts = {
      monospace = {
        package = pkgs.monocraft;
        name = "Monocraft Nerd Font";
      };
      sansSerif = {
        package = pkgs.monocraft;
        name = "Monocraft";
      };
      serif = {
        package = pkgs.monocraft;
        name = "Monocraft";
      };
      sizes = {
        applications = 10;
        terminal = 10;
        desktop = 10;
        popups = 10;
      };
    };

    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 1.0;
      popups = 0.9;
    };

    image = null;

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    targets = {
      hyprland.enable = false;
      waybar.enable = false;
      swaync.enable = false;
      hyprlock.enable = false;
      wofi.enable = false;
      kitty.variant256Colors = true;
    };
  };
}
