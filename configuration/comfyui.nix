{ config, lib, pkgs, ... }:

let
  nvmeMount = lib.optional (config.fileSystems ? "/mnt/nvme") "mnt-nvme.mount";
in
{
  services.comfyui = {
    enable = true;

    acceleration = "cuda";

    port = 8188;
    host = "0.0.0.0";

    home = "/mnt/nvme/comfyui";
  };

  systemd.services.comfyui = lib.mkIf (nvmeMount != [ ]) {
    requires = nvmeMount;
    after = nvmeMount;
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "comfyui";
      Group = "comfyui";
    };
  };

  users.users.comfyui = {
    isSystemUser = true;
    group = "comfyui";
  };

  users.groups.comfyui = { };

  systemd.tmpfiles.rules = [
    "d /mnt/nvme/comfyui 0750 comfyui comfyui -"
  ];
}
