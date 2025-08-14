# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, unstable,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./zapret.nix
    ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
	Experimental = true;
      };
    };
  };

  fileSystems."/mnt/nvme" = {
    device = "/dev/disk/by-uuid/f6be5257-503c-49d2-b856-939e08dc73d5";
    fsType = "btrfs";
    options = [ "noatime" "ssd" ];
  };

  fileSystems."/mnt/archroot" = {
    device = "/dev/disk/by-uuid/f5e0ce07-1227-4fcb-8674-a5412e784f90";
    fsType = "btrfs";
    options = [ "subvol=@" "noatime" "ssd" ];
  };

  fileSystems."/mnt/archhome" = {
    device = "/dev/disk/by-uuid/f5e0ce07-1227-4fcb-8674-a5412e784f90";
    fsType = "btrfs";
    options = [ "subvol=@home" "noatime" "ssd" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "timofey"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Omsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

  security.polkit.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ru";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tima = {
    isNormalUser = true;
    description = "timofey";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = "${pkgs.fish}/bin/fish";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  unstable.discord
  unstable.betterdiscordctl
  unstable.hyprland
  unstable.waybar
  swaybg
  hyprshot
  hyprlock
  zoxide
  vulkan-tools
  ly
  jq
  socat
  git
  upower
  swaynotificationcenter
  kitty
  telegram-desktop
  wofi
  mc
  steam
  btop-cuda
  killall
  pavucontrol
  fastfetch
  gsimplecal
  cliphist
  wl-clipboard
  home-manager
  nftables
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  fonts.packages = with pkgs; [
    monocraft
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.hyprland ={
    enable = true;
    xwayland.enable = true;
  };

  programs.firefox.enable = true;

  programs.fish.enable = true;

  programs.zoxide.enableFishIntegration = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.displayManager.ly.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
