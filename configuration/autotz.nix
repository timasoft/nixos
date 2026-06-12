{ pkgs, ... }:

{
  systemd.services.autotz = {
    description = "Set timezone based on public IP";
    serviceConfig.Type = "oneshot";
    script = ''
      tz=$(${pkgs.curl}/bin/curl -s --connect-timeout 5 http://ip-api.com/json/?fields=timezone | ${pkgs.jq}/bin/jq -r .timezone)
      if [[ -n "$tz" && "$tz" != "null" ]]; then
        ${pkgs.systemd}/bin/timedatectl set-timezone "$tz"
      fi
    '';
  };

  systemd.timers.autotz = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "30s";
      OnUnitActiveSec = "1h";
    };
  };

  networking.networkmanager.dispatcherScripts = [{
    type = "basic";
    source = pkgs.writeShellScript "autotz-dispatch" ''
      if [ "$2" = "up" ]; then
        ${pkgs.systemd}/bin/systemctl start autotz.service
      fi
    '';
  }];
}
