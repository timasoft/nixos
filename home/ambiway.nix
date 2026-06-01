{ config, pkgs, ... }:

{
  home.file.".config/ambiway/config.toml".source = ./ambiway/config.toml;
}
