{ config, pkgs, ... }:

{
  systemd.user.services.flatpak-update-all = {
    description = "Flatpak: update all user apps";
    path = [ pkgs.flatpak ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak update -y --user";
    };
  };

  systemd.user.timers.flatpak-update-all = {
    description = "Timer: update user flatpaks daily";
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = "true";
    };
    unitConfig = {
      Unit = "flatpak-update-all.service";
    };
  };
}
