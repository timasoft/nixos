{ config, pkgs, unstable, ... }:

{
  home.stateVersion = "25.05";
  home.username = "tima";
  home.homeDirectory = "/home/tima";

  imports = [
    ./home/nvim.nix
    ./home/flatpak.nix
    ./home/theme.nix
    ./home/kitty.nix
    ./home/fish.nix
    ./home/pkgs.nix
  ];

  programs.git = {
    enable = true;
    userName = "timasoft";
    userEmail = "tima.klester@yandex.ru";
  };
}
