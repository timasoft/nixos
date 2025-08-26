{ config, pkgs, unstable, ... }:

{
  home.stateVersion = "25.05";
  home.username = "tima";
  home.homeDirectory = "/home/tima";

  home.packages = with pkgs; [
    pipx
    lazygit
    neovide
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
    ./home/kitty.nix
    ./home/fish.nix
  ];

  programs.git = {
    enable = true;
    userName = "timasoft";
    userEmail = "tima.klester@yandex.ru";
  };
}

