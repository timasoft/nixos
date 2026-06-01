{ config, pkgs, ... }:

{
  home.file.".config/niri/wofi-calc.sh" = {
    executable = true;
    source = ./niri/wofi-calc.sh;
  };

  xdg.configFile."niri/config.kdl" = {
    source = ./niri/config.kdl;
  };
}
