{ config, lib, pkgs, unstable, ... }:

{
  services.comfyui = {
    enable = true;

    gpuSupport = "cuda";

    enableManager = true;

    port = 8188;
    listenAddress = "0.0.0.0";

    dataDir = "/mnt/nvme/comfyui";

    package = unstable.comfy-ui-cuda;

    requiresMounts = lib.optional (config.fileSystems ? "/mnt/nvme") "mnt-nvme.mount";
  };
}
