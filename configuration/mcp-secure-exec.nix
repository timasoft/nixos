{ config, lib, pkgs, unstable, ... }:

{
  services.mcp-secure-exec = {
    enable = true;

    transport = "streamable-http";
    bind = "0.0.0.0:3344";

    commands = [
      {
        name = "list-available-paths";
        template = ''echo \"Allowed paths: /home/tima/.local /home/tima/.config /home/tima/build /home/tima/comfyui-nix-devshell /home/tima/Desktop /home/tima/Downloads /home/tima/git /home/tima/nixos /home/tima/temp /home/tima/test /home/tima/Videos /home/tima/Видео /home/tima/Загрузки /home/tima/Изображения /mnt/nvme\"'';
      }
      { name = "read-file"; template = "bat {path}"; }
      { name = "list"; template = "eza -la {path}"; }
      { name = "find"; template = "fd {regex} {path} --type f"; }
      { name = "grep"; template = "rg -rn {pattern} {path}"; }
    ];

    extraPackages = with pkgs; [ bat git fd ripgrep eza procps coreutils ];

    restrictFilesystem = true;
    protectHome = false;
  };

  systemd.tmpfiles.rules = [
    "z /home/tima/.local 0755 tima users -"
    "z /home/tima/.config 0755 tima users -"
    "z /home/tima/build 0755 tima users -"
    "z /home/tima/comfyui-nix-devshell 0755 tima users -"
    "z /home/tima/Desktop 0755 tima users -"
    "z /home/tima/Downloads 0755 tima users -"
    "z /home/tima/git 0755 tima users -"
    "z /home/tima/nixos 0755 tima users -"
    "z /home/tima/temp 0755 tima users -"
    "z /home/tima/test 0755 tima users -"
    "z /home/tima/Videos 0755 tima users -"
    "z /home/tima/Видео 0755 tima users -"
    "z /home/tima/Загрузки 0755 tima users -"
    "z /home/tima/Изображения 0755 tima users -"
    "z /mnt/nvme 0755 tima users -"
  ];
}
