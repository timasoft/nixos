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
}
