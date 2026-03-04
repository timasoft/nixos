{ config, pkgs, ... }: {
  services.syncthing = {
    enable = true;
    user = "tima";
    group = "users";
    dataDir = "/home/tima/syncthing";
  };
}
