{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    pipx
    neovide
    ghfetch
    onefetch
    yandex-music
    telegram-desktop
    prismlauncher
    unstable.discord
    unstable.betterdiscordctl
    nvtopPackages.nvidia
    libreoffice
    git-lfs
    gimp
    kdePackages.kdenlive
  ];

  programs.obs-studio.enable = true;
  programs.lazygit.enable = true;
}
