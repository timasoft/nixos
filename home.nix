{ config, pkgs, unstable, ... }:

{
  home.stateVersion = "25.11";
  home.username = "tima";
  home.homeDirectory = "/home/tima";

  imports = [
    ./home/nvim.nix
    ./home/kitty.nix
    ./home/fish.nix
    ./home/pkgs.nix
    ./home/git.nix
    ./home/stylix.nix
  ];
}
