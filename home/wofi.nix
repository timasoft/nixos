{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;

    settings = {
      term = "kitty";
      allow_images = true;
      insensitive = true;
    };

    style = ''
      * {
          font-family: "Monocraft";
          color: #f0f8f8ff;
      }

      #window {
          background-color: rgba(5,0,32,0.6);
          border-radius: 10px;
          border-style: solid;
          border-width: 1px;
          border-color: rgb(189,147,249);
      }

      #input {
          background-color: transparent;
          border-radius: 15px;
          margin: 5px;
      }

      #unselected {
          margin: 0 10px;
      }

      #selected {
          margin: 0 5px;
          font-size: 15px;
      }

      #entry:selected {
          margin: 1px;
      }
    '';
  };
}
