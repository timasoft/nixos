{ config, pkgs, ... }:

let
  asciiFilter = pkgs.writeShellScriptBin "rastertokpsl-ascii" ''
    args=( "$@" )
    args[2]="$( ${pkgs.icu.dev}/bin/uconv -x 'Any-Latin; Latin-ASCII' <<<"''${args[2]}" | LC_ALL=C tr -cd '[:print:]' | tr -d '"\\' | cut -c1-100 )"
    [ -n "''${args[2]}" ] || args[2]="job-''${args[0]}"
    exec ${pkgs.cups-kyocera}/lib/cups/filter/rastertokpsl "''${args[@]}"
  '';
in
{
  services.printing.enable = true;

  services.printing.drivers = with pkgs; [ cups-kyocera ];

  users.users.tima.extraGroups = [ "lp" ];

  system.activationScripts.cupsKyoceraPpd = ''
    if [ -d /var/lib/cups/ppd ]; then
      for ppd in /var/lib/cups/ppd/*.ppd; do
        [ -e "$ppd" ] || continue
        ${pkgs.gnused}/bin/sed -i "s#/nix/store/[a-z0-9]*-cups-kyocera-[^/]*#${pkgs.cups-kyocera}#g" "$ppd"
        ${pkgs.gnused}/bin/sed -i "s#^\(\*cupsFilter[0-9]*:\).*\$#\1 \"application/vnd.cups-raster 0 ${asciiFilter}/bin/rastertokpsl-ascii\"#" "$ppd"
      done
    fi
    if ${pkgs.systemd}/bin/systemctl -q is-active cups.service 2>/dev/null; then
      ${pkgs.systemd}/bin/systemctl restart cups.service
    fi
  '';
}
