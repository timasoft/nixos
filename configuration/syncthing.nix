{ config, pkgs, ... }: {
  services.syncthing = {
    enable = true;
    user = "tima";
    group = "users";
    dataDir = "/mnt/nvme/syncthing";
  };
}
