{
  fileSystems."/mnt/sdcard" = {
    device = "/dev/disk/by-uuid/fbbbdc1b-4f1e-4c7a-b6dc-a85c4c02b7a4";
    fsType = "ext4";
    options = [
      "noatime"
      "rw"
      "nofail"
      "x-systemd.automount"
      "uid=1000"
      "gid=1000"
      "dmask=022"
      "fmask=133"
    ];
  };
}
