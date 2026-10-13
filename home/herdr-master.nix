{ config, lib, pkgs, hmMaster, ... }@args:

let
  genPath = hmMaster + "/modules/lib/generators.nix";

  call = f: avail:
    if builtins.isFunction f
    then f (lib.intersectAttrs (builtins.functionArgs f) avail)
    else f;

  extLib = lib.extend (final: prev: {
    hm = prev.hm // {
      generators =
        (prev.hm.generators or { })
        // call (import genPath) { lib = final; inherit pkgs; };
    };
  });

  herdrModule = import (hmMaster + "/modules/programs/herdr.nix");
in
herdrModule (args // { lib = extLib; })
