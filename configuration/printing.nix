{ config, pkgs, ... }:

{
  services.printing.enable = true;

  services.printing.drivers = with pkgs; [ cups-kyocera ];

  users.users.tima.extraGroups = [ "lp" ];
}
