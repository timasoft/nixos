{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    pipx
    # neovide
    ghfetch
    onefetch
    # yandex-music
    telegram-desktop
    # prismlauncher
    # unstable.discord
    # unstable.betterdiscordctl
    # nvtopPackages.nvidia
    libreoffice
  ];

  programs.lazygit.enable = true;
}
