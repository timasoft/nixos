{ config, pkgs, unstable, ... }:

{
  home.stateVersion = "25.05";
  home.username = "tima";

  home.packages = with pkgs; [ lazygit ];

  imports = [
    ./home/nvim.nix
  ];

  programs.git = {
    enable = true;
    userName = "timasoft";
    userEmail = "tima.klester@yandex.ru";
  };
}

