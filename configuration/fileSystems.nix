{
  fileSystems."/mnt/sdcard" = {
  device = "/dev/mmcblk2p1";
  fsType = "vfat";
  options = [
    "rw"
    "relatime"
    "uid=1000"
    "gid=1000"
    "utf8"
    "shortname=mixed"
    "dmask=022"
    "fmask=133"
  ];
};
}
