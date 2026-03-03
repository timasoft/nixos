{ unstable, ... }:

{
  services.ollama = {
    enable = true;
    models = "/mnt/nvme/ollama/models";
    acceleration = "cuda";
    user = "ollama";
    package = unstable.ollama-cuda;
    host = "0.0.0.0";
  };
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    package = unstable.open-webui;
  };
}
