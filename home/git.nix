{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "timasoft";
      user.email = "tima.klester@yandex.ru";

      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    };
  };
}
