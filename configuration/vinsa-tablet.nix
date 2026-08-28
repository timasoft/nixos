{ config, pkgs, lib, vinsa-tablet, ... }:

let
  vinsaDriver = pkgs.rustPlatform.buildRustPackage {
    pname = "v1060p";
    version = "0.0.0";

    src = "${vinsa-tablet}/driver";

    cargoLock.lockFile = "${vinsa-tablet}/driver/Cargo.lock";

    nativeBuildInputs = [ pkgs.pkg-config ];

    meta = with lib; {
      description = "Linux driver for VINSA 1060 Plus (or similar) drawing tablet(s)";
      license = licenses.gpl3Plus;
      mainProgram = "v1060p";
    };
  };
in
{
  options.services.vinsa-tablet = {
    enable = lib.mkEnableOption "VINSA 1060 Plus tablet driver";
  };

  config = lib.mkIf config.services.vinsa-tablet.enable {
    environment.systemPackages = [ vinsaDriver ];

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="08f2", ATTR{idProduct}=="6811", MODE="0666"
      SUBSYSTEM=="input", GROUP="input", MODE="0666"
      KERNEL=="uinput", MODE="0666", GROUP="input"
    '';

    systemd.services.vinsa-tablet = {
      description = "VINSA 1060 Plus tablet driver";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${vinsaDriver}/bin/v1060p";
        Restart = "on-failure";
        RestartSec = 5;
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
