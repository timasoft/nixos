{
  fileSystems."/mnt/sdcard" = {
  device = "/dev/disk/by-uuid/65C2-E2A5";
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
