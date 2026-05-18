{ config, lib, pkgs, ... }:

let
  vgName = "vm-pool";
in
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  services.lvm.enable = true;

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    user = "root"
    group = "root"
    dynamic_ownership = 0
  '';
}
