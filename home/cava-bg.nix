{ config, pkgs, lib, ... }:

{
  systemd.user.services."cava-bg" = {
    Unit = {
      After = [ "swaybg.service" ];
      PartOf = [ "swaybg.service" ];
    };
  };

  programs.cava-bg = {
    enable = true;

    systemd = {
      enable = true;
      supervisor = true;
    };

    settings = {
      general = {
        framerate = 180;
        dynamic_colors = false;
        corner_radius = 0.0;
        disable_audio = false;
      };

      audio = {
        bar_count = 70;
        gap = 0.1;
        bar_alpha = 1.0;
        height_scale = 0.6;
        smoothing = 0.8;
        max_bar_height = 100.0;
        min_bar_height = 0.0;
        bar_shape = "Rectangle";
        visualization_mode = "Bars";
        show_visualizer = true;
      };

      colors = {
        extract_from_wallpaper = false;
        use_gradient = true;
        gradient_direction = "BottomToTop";
        palette = [
          [ 0.58 0.89 0.84 1.0 ]
          [ 0.45 0.78 0.93 1.0 ]
          [ 0.80 0.65 0.97 1.0 ]
          [ 0.96 0.76 0.90 1.0 ]
        ];
      };

      display = {
        position = "Fill";
        layer = "Background";
        opacity = 1.0;
      };

      xray = {
        enabled = false;
      };

      parallax = {
        enabled = false;
      };

      performance = {
        vsync = true;
        multi_threaded_decode = true;

        idle_mode = {
          enabled = true;
          audio_threshold = 0.015;
          timeout_seconds = 5.0;
          idle_fps = 10;
          exit_transition_ms = 250;
        };

        video_decoder = {
          lazy_init = true;
          auto_shutdown = true;
          shutdown_after_seconds = 20.0;
          pause_on_idle = true;
        };
      };

      advanced = {
        verbose_logging = false;
        frame_rate_limit = 180;
        layer_cache_size = 5;
      };
    };
  };
}
