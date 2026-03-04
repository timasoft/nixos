{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    pipx
    # neovide
    ghfetch
    onefetch
    yandex-music
    telegram-desktop
    libreoffice
    tauon
  ];

  programs.lazygit.enable = true;
}
