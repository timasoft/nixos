{ config, pkgs, unstable, ... }:

{
  home.stateVersion = "25.05";
  home.username = "tima";
  home.homeDirectory = "/home/tima";

  home.packages = with pkgs; [
    lazygit
    neovide
    flatpak
    yandex-music
    telegram-desktop
    prismlauncher
    unstable.discord
    unstable.betterdiscordctl
    nvtopPackages.nvidia
  ];

  imports = [
    ./home/nvim.nix
    ./home/flatpak.nix
    ./home/theme.nix
  ];

  programs.git = {
    enable = true;
    userName = "timasoft";
    userEmail = "tima.klester@yandex.ru";
  };
}

