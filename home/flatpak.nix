{ config, pkgs, ... }:

{
  systemd.user.services."flatpak-update-all" = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak update -y --user";
    };
  };

  systemd.user.timers."flatpak-update-all" = {
    Timer = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
      Unit = "flatpak-update-all.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
