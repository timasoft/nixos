{ config, pkgs, ... }:

{
  boot.kernelModules = [ "v4l2loopback" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2 video_nr=2,3 exclusive_caps=1
  '';

  environment.systemPackages = with pkgs; [
    v4l-utils
  ];
}
