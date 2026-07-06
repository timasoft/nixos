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
      ./configuration/homepage.nix
      ./configuration/searx.nix
      ./configuration/pkgs.nix
      ./configuration/v4l2loopback.nix
      ./configuration/printing.nix
      ./configuration/plymouth.nix
      ./configuration/nh.nix
      ./configuration/llama-server.nix
      ./configuration/mcp-secure-exec.nix
      ./configuration/unsloth-studio.nix
      ./configuration/comfyui.nix
      ./configuration/virtualization.nix
      ./configuration/syncthing.nix
      ./configuration/niri.nix
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
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/mnt/nvme/docker";
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
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "kvm" ];
    packages = with pkgs; [];
    shell = "${pkgs.fish}/bin/fish";
  };

  systemd.tmpfiles.rules = [
    "d /home/tima 0711 tima users -"
  ];

  environment.variables.EDITOR = "nvim";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.QML_IMPORT_PATH = "${pkgs.hyprland-qt-support}/lib/qt-6/qml";

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND     = "wayland";
    QT_QPA_PLATFORM = "wayland";

    FLAKE = "/home/tima/nixos";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.hyprland = {
    xwayland.enable = true;
  };

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

  services.hardware.openrgb.enable = true;
  # services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;

  services.llama-server = {
    enable = true;

    models = {
      qwen35 = {
        modelPath = "/mnt/nvme/ggufs/Qwen3.5-4B-UD-Q6_K_XL.gguf";
        mmprojPath = "/mnt/nvme/ggufs/mmproj-F16(qwen3.5).gguf";
        port = 8088;
        requiredVram = 8000;
        ctxSize = 131072;
        parallel = 2;
        extraArgs = [
          "--webui-mcp-proxy"
          "--reasoning auto"
        ];
      };

      granite = {
        modelPath = "/mnt/nvme/ggufs/granite-4.1-3b-UD-Q8_K_XL.gguf";
        port = 8012;
        requiredVram = 6500;
        ctxSize = 32768;
        parallel = 4;
      };

      ornith = {
        modelPath = "/mnt/nvme/ggufs/ornith-1.0-9b-Q6_K.gguf";
        port = 8080;
        requiredVram = 9000;
        ctxSize = 131072;
        parallel = 1;
        extraArgs = [
          "--webui-mcp-proxy"
          "--reasoning auto"
        ];
      };
    };
  };

  services.unsloth-studio.enable = false;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    trusted-users = [ "root" "tima" ];

    substituters = [
      "https://cache.nixos.org"
      "https://comfyui.cachix.org"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://ai.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://numtide.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
    priority = 100;
  };

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
  system.stateVersion = "25.11"; # Did you read the comment?

}
