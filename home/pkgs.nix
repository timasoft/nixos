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
    (unstable.discord.override { withVencord = true; })
    # unstable.vesktop
    # unstable.betterdiscordctl
    # nvtopPackages.nvidia
    libreoffice
    gimp
    # kdePackages.kdenlive
    tauon
    unstable.nautilus
  ];

  programs.obs-studio.enable = true;
}

