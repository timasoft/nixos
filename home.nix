{ config, pkgs, unstable, ... }:

{
  home.stateVersion = "25.11";
  home.username = "tima";
  home.homeDirectory = "/home/tima";

  imports = [
    ./home/nvim.nix
    ./home/flatpak.nix
    ./home/kitty.nix
    ./home/fish.nix
    ./home/pkgs.nix
    ./home/git.nix
    ./home/stylix.nix
    ./home/noctalia.nix
    ./home/ambiway.nix
    ./home/niri.nix
    ./home/wofi.nix
    ./home/cava-bg.nix
    ./home/services.nix
  ];

  xdg.configFile."fontconfig/conf.d/99-monocraft.conf".text = ''
    <fontconfig>
      <selectfont>
        <rejectfont>
          <glob>*Monocraft-no-ligatures*</glob>
        </rejectfont>
      </selectfont>
    </fontconfig>
  '';
}
