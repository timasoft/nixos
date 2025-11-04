{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    pipx
    lazygit
    neovide
    ghfetch
    onefetch
    # yandex-music
    telegram-desktop
    prismlauncher
    unstable.discord
    unstable.betterdiscordctl
    nvtopPackages.nvidia
    libreoffice
    git-lfs
  ];

  programs.obs-studio.enable = true;
}
