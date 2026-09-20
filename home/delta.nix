{ config, pkgs, ... }:

{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      hyperlinks = true;
      side-by-side = true;
      true-color = "always";
    };
  };
}

