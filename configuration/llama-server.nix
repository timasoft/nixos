{ config, pkgs, unstable, lib, ... }:

let
  llamaServer = "${unstable.llamaPackages.llama-cpp}/bin/llama-server";

  nvidiaUtils = config.hardware.nvidia.package.out;

  llamaScript = pkgs.writeShellScriptBin "llama-cpp" ''
    #!/bin/bash

    REQUIRED_VRAM_MB="''${REQUIRED_VRAM_MB:-8000}"
    MODEL_PATH="''${MODEL_PATH}"
    MMPROJ_PATH="''${MMPROJ_PATH}"

    export PATH="${nvidiaUtils}/bin:$PATH"

    if [ ! -f "$MODEL_PATH" ]; then
      echo "Error: Model file not found at $MODEL_PATH"
      exit 1
    fi

    ARGS=(
      -m "$MODEL_PATH"
      --mmproj "$MMPROJ_PATH"
      --n-gpu-layers 99
      --host 0.0.0.0
      --port 8012
      --temp 0.2
      --top-p 0.95
      --top-k 40
      --min-p 0.05
      --ctx-size 131072
      --parallel 2
      --flash-attn on
      --sleep-idle-seconds 30
      --cache-type-k q8_0 --cache-type-v q8_0
      --webui-mcp-proxy
      --reasoning auto
    )

    launch_server() {
      echo "Launching llama-server..."
      exec ${llamaServer} "''${ARGS[@]}"
    }

    if ! command -v nvidia-smi &> /dev/null; then
      echo "nvidia-smi not found, launching without VRAM check..."
      launch_server
    fi

    echo "Waiting for VRAM availability (''${REQUIRED_VRAM_MB} MB)..."

    while true; do
      FREE_VRAM=$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits 2>/dev/null | head -n 1)

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
in
{
  options.services.llama-server = {
    enable = lib.mkEnableOption "Enable Llama Server service";
    modelPath = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/nvme/ggufs/Qwen3.5-4B-UD-Q6_K_XL.gguf";
      description = "Path to the GGUF model file";
    };
    mmprojPath = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/nvme/ggufs/mmproj-F16(qwen3.5).gguf";
      description = "Path to the mmproj file";
    };
    requiredVram = lib.mkOption {
      type = lib.types.int;
      default = 8000;
      description = "Required free VRAM in MB";
    };
  };

  config = lib.mkIf config.services.llama-server.enable {
    environment.systemPackages = [ llamaScript ];

    systemd.services.llama-server = {
      description = "Llama.cpp Server with VRAM monitoring";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "nvidia-persistenced.service" ]
              ++ lib.optional (config.fileSystems ? "/mnt/nvme") "mnt-nvme.mount";

      requires = lib.optional (config.fileSystems ? "/mnt/nvme") "mnt-nvme.mount";

      serviceConfig = {
        Type = "simple";
        ExecStart = "${llamaScript}/bin/llama-cpp";
        Restart = "on-failure";
        RestartSec = 30;

        Environment = [
          "MODEL_PATH=${config.services.llama-server.modelPath}"
          "MMPROJ_PATH=${config.services.llama-server.mmprojPath}"
          "REQUIRED_VRAM_MB=${toString config.services.llama-server.requiredVram}"
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
  };
}
