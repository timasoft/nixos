{ config, pkgs, lib, ... }:

let
  s = import /home/tima/secrets/vpn.nix;
in
{
  services.sing-box = {
    enable = true;
    settings = {
      log.level = "info";

      dns = {
        servers = [
          {
            type = "tls";
            tag = "dns-remote";
            server = "8.8.8.8";
            server_port = 853;
            detour = "proxy-out";
          }
        ];
        rules = [{ action = "route"; server = "dns-remote"; }];
      };

      inbounds = [{
        type = "tun";
        tag = "tun-in";
        interface_name = "tun0";
        address = [ "172.19.0.1/30" "fd00::1/126" ];
        auto_route = true;
        strict_route = true;
      }];

      outbounds = [
        {
          type = "vless";
          tag = "proxy-out";
          server = s.vpsIp;
          server_port = s.vpsPort;
          uuid = s.uuid;
          flow = "xtls-rprx-vision";
          packet_encoding = "xudp";
          tls = {
            enabled = true;
            server_name = s.sni;
            reality = {
              enabled = true;
              public_key = s.publicKey;
              short_id = s.shortId;
            };
            utls = { enabled = true; fingerprint = "chrome"; };
          };
        }
        { type = "direct"; tag = "direct-out"; }
      ];

      route = {
        rules = [
          { ip_cidr = [ "${s.vpsIp}/32" ]; outbound = "direct-out"; }
          { ip_is_private = true; outbound = "direct-out"; }
        ];
        final = "proxy-out";
        auto_detect_interface = true;
      };
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "tima" ];
      commands = [
        { command = "${pkgs.systemd}/bin/systemctl start sing-box"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.systemd}/bin/systemctl stop sing-box"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    libnotify
    (writeShellScriptBin "vpn-toggle" ''
      if systemctl is-active --quiet sing-box; then
        sudo ${pkgs.systemd}/bin/systemctl stop sing-box
        notify-send "VPN Disabled" "Direct internet connection restored" -i network-offline
      else
        sudo ${pkgs.systemd}/bin/systemctl start sing-box
        notify-send "VPN Enabled" "Routing through VPS securely" -i network-vpn
      fi
    '')
  ];

  systemd.services.sing-box.wantedBy = lib.mkForce [];

  networking.firewall.trustedInterfaces = [ "tun0" ];
  networking.nftables.enable = true;
}
