{
  fileSystems."/mnt/nvme" = {
    device = "/dev/disk/by-uuid/f6be5257-503c-49d2-b856-939e08dc73d5";
    fsType = "btrfs";
    options = [ "noatime" "ssd" ];
  };

  fileSystems."/mnt/archroot" = {
    device = "/dev/disk/by-uuid/f5e0ce07-1227-4fcb-8674-a5412e784f90";
    fsType = "btrfs";
    options = [ "subvol=@" "noatime" "ssd" ];
  };

  fileSystems."/mnt/archhome" = {
    device = "/dev/disk/by-uuid/f5e0ce07-1227-4fcb-8674-a5412e784f90";
    fsType = "btrfs";
    options = [ "subvol=@home" "noatime" "ssd" ];
  };
}
