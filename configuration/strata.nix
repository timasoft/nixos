{ config, lib, pkgs, strataPkg, ... }:

let
  cfg = config.services.strata;
  stateDir = "/var/lib/strata";

  # The repository's seed profile travels with the package; a caller-named one wins.
  engineArgs = [ "--pack" cfg.pack "--native" cfg.native ]
    ++ cfg.engineArgs
    ++ lib.optionals (!lib.elem "--expert-profile" cfg.engineArgs) [
      "--expert-profile" "${strataPkg}/lib/strata/data/expert-profile.bin"
    ]
    ++ [ "--conversation-spill-dir" "${stateDir}/conversation-spill" ];

  runConfig = pkgs.writeText "strata-run.json" (builtins.toJSON ({
    exe = "${strataPkg}/lib/strata/engine/strata";
    args = engineArgs;
    cwd = stateDir;
    tokenizer = "${cfg.pack}/tokenizer";
    model_name = cfg.modelName;
    log = "${stateDir}/strata.log";
    env = cfg.env;
    gpu = cfg.gpus;
  } // lib.optionalAttrs cfg.learnExpertProfile {
    expert_profile_save = "${stateDir}/${cfg.modelName}-expert-profile.bin";
  } // lib.optionalAttrs (cfg.mmproj != "") {
    vision = {
      exe = "${strataPkg}/lib/strata/engine/strata-vision";
      mmproj = cfg.mmproj;
      model = cfg.native;
    };
  }));

  # The server dlopens libnvidia-ml.so.1 by bare name, and only LD_LIBRARY_PATH can find it there:
  # python's runpath has no driver and NixOS keeps no ld.so.cache. Without this the monitor's
  # hardware screen is empty.
  nvidiaLibs = lib.makeLibraryPath [ config.hardware.nvidia.package.out ];

in
{
  options.services.strata = {
    enable = lib.mkEnableOption "Strata inference server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address to bind to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port to listen on.";
    };

    pack = lib.mkOption {
      type = lib.types.str;
      description = "The prepared model folder (--pack).";
    };

    native = lib.mkOption {
      type = lib.types.str;
      description = "The GGUF the engine reads (--native).";
    };

    modelName = lib.mkOption {
      type = lib.types.str;
      default = "strata";
      description = "Name the API reports, and the stem of the learned profile file.";
    };

    mmproj = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Vision projector; no picture reader is started when empty.";
    };

    gpus = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ 0 ];
      description = "Cards the engine may use, as nvidia-smi numbers them. More than one is a layer split, which the engine divides between them itself unless --layer-split is given in engineArgs.";
    };

    engineArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Engine arguments, one per element.";
      example = [ "--spec" "4" "--max-context" "131072" ];
    };

    env = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Environment for the engine.";
    };

    learnExpertProfile = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Save what the adaptive tier learned and start the next run from it.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ strataPkg ];
    environment.variables.STRATA_URL = "http://${cfg.host}:${toString cfg.port}";

    users.groups.strata = { };

    users.users.strata = {
      isSystemUser = true;
      group = "strata";
      home = stateDir;
    };

    systemd.services.strata = {
      description = "Strata inference server (${cfg.modelName})";

      # serve's engine_arch_note asks nvidia-smi for the cards' compute capabilities; the unit's
      # default PATH has no driver tools, so without this its warning is silently skipped.
      path = [ config.hardware.nvidia.package.bin ];

      serviceConfig = {
        ExecStart = "${strataPkg}/bin/strata-server --engine strata --config ${runConfig} --host ${cfg.host} --port ${toString cfg.port}";

        User = "strata";
        Group = "strata";
        StateDirectory = "strata";
        StateDirectoryMode = "0770";

        Environment = [ "LD_LIBRARY_PATH=${nvidiaLibs}" ];

        DevicePolicy = "closed";
        DeviceAllow = [ "/dev/nvidiactl" "/dev/nvidia-uvm" ]
          ++ map (i: "/dev/nvidia${toString i}") cfg.gpus;

        Restart = "on-failure";
        RestartSec = 30;
      };
    };
  };
}
