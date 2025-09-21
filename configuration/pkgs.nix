{ config, pkgs, unstable, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    unstable.hyprland
    unstable.waybar
    swaybg
    hyprshot
    hyprlock
    zoxide
    vulkan-tools
    ly
    jq
    fd
    eza
    dust
    ncdu
    bat
    tokei
    git
    upower
    swaynotificationcenter
    kitty
    wofi
    mc
    yazi
    mangohud
    btop-cuda
    killall
    pavucontrol
    fastfetch
    pfetch
    gsimplecal
    cliphist
    wl-clipboard
    home-manager
    nftables
    neovim
    flatpak
    fishPlugins.tide
    hyprland-qt-support
    hyprsysteminfo
    gpu-screen-recorder-gtk
    libqalculate
    swappy
    wofi-emoji
    wofi-power-menu
    #  wget
    byedpi
    marp-cli
  ];

  fonts.packages = with pkgs; [
    monocraft
    nerd-fonts.symbols-only
  ];

  programs.hyprland.enable = true;

  programs.firefox.enable = true;

  programs.fish.enable = true;

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  programs.zoxide.enableFishIntegration = true;

  programs.gpu-screen-recorder.enable = true;
}
