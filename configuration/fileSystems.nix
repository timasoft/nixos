{
  fileSystems."/mnt/nvme" = {
    device = "/dev/disk/by-uuid/f6be5257-503c-49d2-b856-939e08dc73d5";
    fsType = "btrfs";
    options = [ "noatime" "ssd" ];
  };
}
