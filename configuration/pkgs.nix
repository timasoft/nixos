{ config, pkgs, unstable, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    unstable.hyprland
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
    fzf
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
    unstable.fishPlugins.tide
    hyprland-qt-support
    hyprsysteminfo
    gpu-screen-recorder-gtk
    libqalculate
    swappy
    wofi-emoji
    wofi-power-menu
    wget
    wf-recorder
    byedpi
    marp-cli
    adwsteamgtk
    mpv
    ripgrep
    nix-output-monitor
    nvd
    unstable.hyprviz
    jdk21
    unstable.llamaPackages.llama-cpp
  ];

  fonts.packages = with pkgs; [
    monocraft
    nerd-fonts.symbols-only
  ];

  programs.hyprland.enable = true;

  programs.firefox.enable = true;

  programs.fish = {
    enable = true;
    package = unstable.fish;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode.enable = true;

  programs.zoxide.enableFishIntegration = true;

  programs.gpu-screen-recorder.enable = true;

  programs.dconf.enable = true;
}
