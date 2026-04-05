{ config, pkgs, unstable, ... }:

let
  cfg = ./noctalia;
in
{
  home.packages = [ unstable.noctalia-shell ];

  home.file.".config/noctalia/settings.json".source = "${cfg}/settings.json";
  home.file.".config/noctalia/colorschemes/050010".source = "${cfg}/colorschemes/050010";
}
