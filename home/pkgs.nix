{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    pipx
    neovide
    ghfetch
    onefetch
    yandex-music
    telegram-desktop
    unstable.prismlauncher
    unstable.discord
    unstable.vesktop
    # unstable.betterdiscordctl
    # nvtopPackages.nvidia
    libreoffice
    gimp
    kdePackages.kdenlive
    tauon
  ];

  programs.obs-studio.enable = true;
  programs.lazygit.enable = true;
}

