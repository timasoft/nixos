{ pkgs, ... }:

let
  purpleDark = pkgs.stdenv.mkDerivation {
    pname = "050010";
    version = "1.0";
    src = ./050010Theme;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/themes/050010
      cp -r $src/* $out/share/themes/050010
    '';
  };
in
{
  home.packages = [
    purpleDark
  ];

  gtk = {
    enable = true;
    theme = {
      package = purpleDark;
      name = "050010";
    };
  };
}

