{ config, lib, pkgs, unstable, ... }:

let
  cfg = config.services.unsloth-studio;
in
{
  options.services.unsloth-studio = {
    enable = lib.mkEnableOption "Enable Unsloth Studio service via Docker";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Port for Unsloth Studio web interface";
    };

    jupyterPort = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port for Jupyter notebook";
    };

    password = lib.mkOption {
      type = lib.types.str;
      default = "unsloth";
      description = "Password for Jupyter and web interface";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/nvme/unsloth-studio";
      description = "Directory for Unsloth Studio data and models";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "unsloth/unsloth:latest";
      description = "Docker image to use";
    };

    llamaServerUrl = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:8088";
      description = "URL of the llama-server instance";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 tima users -"
      "d ${cfg.dataDir}/work 0755 tima users -"
      "d ${cfg.dataDir}/models 0755 tima users -"
      "d ${cfg.dataDir}/datasets 0755 tima users -"
      "d ${cfg.dataDir}/output 0755 tima users -"
    ];

    systemd.services.unsloth-studio = {
      description = "Unsloth Studio - Local LLM Fine-tuning";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "docker.service"
        "nvidia-persistenced.service"
        "llama-server.service"
      ] ++ lib.optional (config.fileSystems ? "/mnt/nvme") "mnt-nvme.mount";

      requires = [ "docker.service" "llama-server.service" ];

      serviceConfig = {
        Type = "simple";

        ExecStartPre = "${pkgs.docker}/bin/docker pull ${cfg.image}";

        ExecStart = ''
          ${pkgs.docker}/bin/docker run --rm --name unsloth-studio \
            --device=nvidia.com/gpu=all \
            --network=host \
            -e JUPYTER_PASSWORD=${cfg.password} \
            -e LLM_SERVER_URL=${cfg.llamaServerUrl} \
            -e LLM_TIMEOUT=3000 \
            -e MAX_PARALLEL_REQUESTS=2 \
            -v ${cfg.dataDir}/work:/workspace/work \
            -v ${cfg.dataDir}/models:/workspace/models \
            -v ${cfg.dataDir}/datasets:/workspace/datasets \
            -v ${cfg.dataDir}/output:/workspace/output \
            ${cfg.image}
        '';

        ExecStop = "${pkgs.docker}/bin/docker stop -t 120 unsloth-studio";

        Restart = "on-failure";
        RestartSec = 30;
        StartLimitBurst = 5;
        StartLimitIntervalSec = 120;

        NoNewPrivileges = true;
        ProtectHome = false;
        ProtectSystem = "full";
        ReadWritePaths = [
          cfg.dataDir
          "/var/run/docker.sock"
        ];

        StandardOutput = "journal";
        StandardError = "journal";

        User = "root";
        Group = "docker";

        KillMode = "process";
        TimeoutStopSec = 180;
        TimeoutStartSec = 3600;

        Environment = [
          "PATH=${lib.makeBinPath [ pkgs.docker ]}"
          "DOCKER_HOST=unix:///var/run/docker.sock"
        ];
      };
    };
  };
}
