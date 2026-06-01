{ config, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 1;
          blur_size = 3;
          color = "rgba(5, 0, 16, 0.5)";
        }
      ];

      input-field = [
        {
          size = "200, 50";
          outline_thickness = 2;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgb(240,200,240)";
          inner_color = "rgb(15, 0, 32)";
          font_color = "rgb(221, 255, 255)";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "<i>Input Password...</i>";
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date '+%T')\"";
          text_align = "center";
          color = "white";
          font_size = 50;
          font_family = "Monocraft";
          rotate = 0;
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<span foreground='##bbeeff'>$(date '+%A %d %B')</span>\"";
          text_align = "center";
          color = "white";
          font_size = 35;
          font_family = "Monocraft";
          rotate = 0;
          position = "0, 40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
