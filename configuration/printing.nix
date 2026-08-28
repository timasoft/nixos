{ config, pkgs, ... }:

{
  services.printing.enable = true;

  services.printing.drivers = with pkgs; [ cups-kyocera ];

  users.users.tima.extraGroups = [ "lp" ];

  system.activationScripts.cupsKyoceraPpd = ''
    if [ -d /var/lib/cups/ppd ]; then
      for ppd in /var/lib/cups/ppd/*.ppd; do
        [ -e "$ppd" ] || continue
        ${pkgs.gnused}/bin/sed -i "s#/nix/store/[a-z0-9]*-cups-kyocera-[^/]*#${pkgs.cups-kyocera}#g" "$ppd"
      done
    fi
    if ${pkgs.systemd}/bin/systemctl -q is-active cups.service 2>/dev/null; then
      ${pkgs.systemd}/bin/systemctl restart cups.service
    fi
  '';
}
