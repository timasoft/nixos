{ config, pkgs, unstable, ambiwayPkg, ... }:

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
    nvtopPackages.nvidia
    libreoffice
    git-lfs
    gimp
    kdePackages.kdenlive
    tauon
    ambiwayPkg
  ];

  programs.obs-studio.enable = true;
  programs.lazygit.enable = true;
}
