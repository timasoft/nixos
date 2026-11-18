{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "timasoft";
        email = "tima.klester@yandex.ru";
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        diffRenderers = [
          {
            command = "delta --paging=never";
            colorArg = "always";
          }
        ];
      };
    };
  };
}
