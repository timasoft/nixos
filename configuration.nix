# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, unstable,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./configuration/fileSystems.nix
      ./configuration/nvidia.nix
      ./configuration/ollama.nix
      ./configuration/homepage.nix
      ./configuration/searx.nix
      ./configuration/llama-cpp.nix
      ./configuration/pkgs.nix
      ./configuration/v4l2loopback.nix
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

  environment.variables.EDITOR = "nvim";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.QML_IMPORT_PATH = "${pkgs.hyprland-qt-support}/lib/qt-6/qml";

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE    = "wayland";
    GDK_BACKEND        = "wayland";
    QT_QPA_PLATFORM    = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
  };

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

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  programs.zoxide.enableFishIntegration = true;

  programs.gpu-screen-recorder.enable = true;

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
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
