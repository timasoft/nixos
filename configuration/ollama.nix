{
  services.ollama = {
    enable = true;
    models = "/mnt/nvme/ollama/models";
    acceleration = "cuda";
    user = "ollama";
  };
  services.open-webui = {
    enable = true;
  };
}
