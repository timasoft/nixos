{ config, pkgs, unstable, lib, ... }:

let
  llamaServer = "${unstable.llamaPackages.llama-cpp}/bin/llama-server";

  nvidiaSmiPath = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi";

  mkLlamaScript = name: modelCfg: pkgs.writeShellScriptBin "llama-cpp-${name}" ''
    #!/bin/bash

    REQUIRED_VRAM_MB="''${REQUIRED_VRAM_MB:-${toString modelCfg.requiredVram}}"
    MODEL_PATH="''${MODEL_PATH}"
    MMPROJ_PATH="''${MMPROJ_PATH}"
    PORT="''${PORT:-${toString modelCfg.port}}"
    NVIDIA_SMI="''${NVIDIA_SMI_BIN:-nvidia-smi}"

    if [ ! -f "$MODEL_PATH" ]; then
      echo "Error: Model file not found at $MODEL_PATH"
      exit 1
    fi

    ARGS=(
      -m "$MODEL_PATH"
      --n-gpu-layers 99
      --host 0.0.0.0
      --port "$PORT"
      --temp ${toString modelCfg.temp}
      --top-p ${toString modelCfg.topP}
      --top-k ${toString modelCfg.topK}
      --min-p ${toString modelCfg.minP}
      --repeat-penalty ${toString modelCfg.repeatPenalty}
      --ctx-size ${toString modelCfg.ctxSize}
      --parallel ${toString modelCfg.parallel}
      --flash-attn on
      --sleep-idle-seconds 30
      --cache-type-k q8_0
      --cache-type-v q8_0
      ${lib.concatStringsSep "\n      " modelCfg.extraArgs}
    )

    if [ -n "$MMPROJ_PATH" ] && [ -f "$MMPROJ_PATH" ]; then
      ARGS+=(--mmproj "$MMPROJ_PATH")
    fi

    launch_server() {
      echo "Launching llama-server for ${name} on port $PORT..."
      exec ${llamaServer} "''${ARGS[@]}"
    }

    if [ ! -x "$NVIDIA_SMI" ]; then
      echo "nvidia-smi not found at $NVIDIA_SMI, launching without VRAM check..."
      launch_server
    fi

    echo "Waiting for VRAM availability (''${REQUIRED_VRAM_MB} MB)..."

    while true; do
      FREE_VRAM=$("$NVIDIA_SMI" --query-gpu=memory.free --format=csv,noheader,nounits 2>/dev/null | head -n 1)

      if [ -z "$FREE_VRAM" ]; then
        echo "Could not read VRAM, launching anyway..."
        launch_server
      fi

      if [ "$FREE_VRAM" -ge "$REQUIRED_VRAM_MB" ]; then
        echo "Sufficient memory: ''${FREE_VRAM} MB. Launching..."
        launch_server
      else
        echo "Insufficient memory. Free: ''${FREE_VRAM} MB, Required: ''${REQUIRED_VRAM_MB} MB. Waiting 10s..."
        sleep 10
      fi
    done
  '';

  mkService = name: modelCfg: script: lib.nameValuePair "llama-server-${name}" {
    description = "Llama.cpp Server (${name}) with VRAM monitoring";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "nvidia-persistenced.service" ]
            ++ lib.optional (config.fileSystems ? "/mnt/nvme") "mnt-nvme.mount";

    requires = lib.optional (config.fileSystems ? "/mnt/nvme") "mnt-nvme.mount";

    serviceConfig = {
      Type = "simple";
      ExecStart = "${script}/bin/llama-cpp-${name}";
      Restart = "on-failure";
      RestartSec = 30;

      Environment = [
        "MODEL_PATH=${modelCfg.modelPath}"
        "MMPROJ_PATH=${modelCfg.mmprojPath}"
        "REQUIRED_VRAM_MB=${toString modelCfg.requiredVram}"
        "PORT=${toString modelCfg.port}"
        "NVIDIA_SMI_BIN=${nvidiaSmiPath}"
      ] ++ lib.optional (config.hardware.nvidia.enabled)
        "LD_LIBRARY_PATH=${lib.makeLibraryPath [ config.hardware.nvidia.package.out ]}";

      DevicePolicy = "closed";
      DeviceAllow = [ "/dev/nvidiactl" "/dev/nvidia0" "/dev/nvidia-uvm" ];

      StandardOutput = "journal";
      StandardError = "journal";

      KillMode = "process";
      TimeoutStopSec = 30;
    };
  };

  modelSubmodule = lib.types.submodule {
    options = {
      modelPath = lib.mkOption {
        type = lib.types.str;
        description = "Path to the GGUF model file";
      };
      mmprojPath = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Path to the mmproj file (optional)";
      };
      port = lib.mkOption {
        type = lib.types.port;
        description = "Port to run the server on";
      };
      requiredVram = lib.mkOption {
        type = lib.types.int;
        default = 8000;
        description = "Required free VRAM in MB";
      };
      temp = lib.mkOption {
        type = lib.types.float;
        default = 0.2;
      };
      topP = lib.mkOption {
        type = lib.types.float;
        default = 0.95;
      };
      topK = lib.mkOption {
        type = lib.types.int;
        default = 40;
      };
      minP = lib.mkOption {
        type = lib.types.float;
        default = 0.05;
      };
      repeatPenalty = lib.mkOption {
        type = lib.types.float;
        default = 1.15;
      };
      ctxSize = lib.mkOption {
        type = lib.types.int;
        default = 8192;
      };
      parallel = lib.mkOption {
        type = lib.types.int;
        default = 1;
      };
      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Additional arguments to pass to llama-server";
        example = [ "--webui-mcp-proxy" "--reasoning auto" ];
      };
    };
  };

  llamaScripts = lib.mapAttrs (name: cfg: mkLlamaScript name cfg) config.services.llama-server.models;
  llamaServices = lib.mapAttrs' (name: cfg: mkService name cfg llamaScripts.${name}) config.services.llama-server.models;

in
{
  options.services.llama-server = {
    enable = lib.mkEnableOption "Enable Llama Server service";

    models = lib.mkOption {
      type = lib.types.attrsOf modelSubmodule;
      default = {};
      description = "Attribute set of model configurations";
    };
  };

  config = lib.mkIf config.services.llama-server.enable {
    environment.systemPackages = lib.attrValues llamaScripts;
    systemd.services = llamaServices;
  };
}
