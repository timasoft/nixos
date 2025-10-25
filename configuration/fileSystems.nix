{
  fileSystems."/mnt/nvme" = {
    device = "/dev/disk/by-uuid/4a198bbb-f4f8-4482-bdf9-3fff71c6adb0";
    fsType = "btrfs";
    options = [ "noatime" "ssd" ];
  };

  fileSystems."/mnt/archroot" = {
    device = "/dev/disk/by-uuid/c0b1d877-a3bc-47e5-a5a6-b8ca5494b0f4";
    fsType = "btrfs";
    options = [ "subvol=@" "noatime" "ssd" ];
  };

  fileSystems."/mnt/archhome" = {
    device = "/dev/disk/by-uuid/c0b1d877-a3bc-47e5-a5a6-b8ca5494b0f4";
    fsType = "btrfs";
    options = [ "subvol=@home" "noatime" "ssd" ];
  };
}
