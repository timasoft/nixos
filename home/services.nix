{ config, pkgs, unstable, ... }:

{
  systemd.user.services = {
    noctalia = {
      Unit = {
        Description = "Noctalia Shell";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${unstable.noctalia-shell}/bin/noctalia-shell";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    cliphist-text = {
      Unit = {
        Description = "Cliphist Text Watcher";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "always";
        RestartSec = 2;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    cliphist-image = {
      Unit = {
        Description = "Cliphist Image Watcher";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "always";
        RestartSec = 2;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    swaybg = {
      Unit = {
        Description = "Sway Background";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        Wants = [ "cava-bg.service" ];
      };
      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${config.home.file.".config/niri/wallpaper.jpg".source}";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    byedpi = {
      Unit = {
        Description = "byedpi";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.byedpi}/bin/ciadpi --disorder 1 --auto=torst --tlsrec 1+s";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
