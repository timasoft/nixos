{ config, pkgs, ... }:

{
  systemd.user.services."flatpak-update-all" = {
    serviceConfig = {
      Type = "oneshot";
      Description = "Flatpak: update all user apps";
      ExecStart = "${pkgs.flatpak}/bin/flatpak update -y --user";
    };
  };

  systemd.user.timers."flatpak-update-all" = {
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
    };
    unitConfig = {
      Unit = "flatpak-update-all.service";
    };
  };
}

