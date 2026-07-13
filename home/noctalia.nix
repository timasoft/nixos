{ config, noctaliaPkg, ... }:

let
  cfg = ./noctalia;
in
{
  home.packages = [ noctaliaPkg ];

  programs.noctalia = {
    enable = true;

    systemd.enable = true;

    settings = {
      audio = {
        enable_overdrive = true;
      };

      bar = {
        default = {
          background_opacity = 0.7;
          end = [ "bluetooth" "volume" "cpu" "ram" "keyboard_layout" "tray" "notifications" ];
          margin_ends = 0;
          position = "bottom";
          radius = 0;
          start = [ "workspaces" "active_window" "media" ];
          thickness = 24;
          widget_spacing = 12;
          monitor = {
            "DP-1" = {
              scale = 1.1;
              thickness = 28;
            };
          };
        };
      };

      control_center = {
        sidebar = "full";
        sidebar_section = "full";
        shortcuts = [
          { type = "bluetooth"; }
          { type = "session"; }
        ];
      };

      desktop_widgets = {
        enabled = false;
      };

      dock = {
        active_scale = 1.1;
        auto_hide = true;
        background_opacity = 0.7;
        enabled = true;
        icon_size = 32;
        inactive_opacity = 0.75;
        inactive_scale = 1.0;
        item_spacing = 0;
        launcher_position = "end";
        magnification_scale = 1.2;
        reserve_space = false;
        show_dots = true;
      };

      location = {
        address = "Омск, Россия";
      };

      lockscreen = {
        blur_intensity = 0.1;
        blurred_desktop = true;
        tint_intensity = 0.2;
      };

      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@DVI-D-1"
          "lockscreen-login-box@DP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
          "lockscreen-widget-0000000000000003"
          "lockscreen-widget-0000000000000004"
        ];
        grid = {
          cell_size = 8;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@DP-1" = {
            box_height = 70.0;
            box_width = 400.0;
            cx = 1280.0;
            cy = 720.0;
            output = "DP-1";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.0;
              background_radius = 12.0;
              input_opacity = 0.7;
              input_radius = 10.0;
              show_caps_lock = true;
              show_keyboard_layout = false;
              show_login_button = false;
              show_password_hint = true;
            };
          };
          "lockscreen-login-box@DVI-D-1" = {
            box_height = 70.0;
            box_width = 400.0;
            cx = 960.0;
            cy = 540.0;
            output = "DVI-D-1";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.0;
              background_radius = 12.0;
              input_opacity = 0.69;
              input_radius = 10.0;
              show_caps_lock = true;
              show_keyboard_layout = false;
              show_login_button = false;
              show_password_hint = true;
            };
          };
          "lockscreen-widget-0000000000000001" = {
            box_height = 96.0;
            box_width = 368.0;
            cx = 1280.0;
            cy = 560.0;
            output = "DP-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background_opacity = 0.0;
              background_padding = 0;
              background_radius = 0;
              format = "{:%T}";
            };
          };
          "lockscreen-widget-0000000000000002" = {
            box_height = 96.0;
            box_width = 368.0;
            cx = 960.0;
            cy = 380.0;
            output = "DVI-D-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background_opacity = 0.0;
              background_padding = 0;
              background_radius = 0;
              format = "{:%T}";
            };
          };
          "lockscreen-widget-0000000000000003" = {
            box_height = 96.0;
            box_width = 416.0;
            cx = 960.0;
            cy = 460.0;
            output = "DVI-D-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background_opacity = 0.0;
              background_padding = 0;
              background_radius = 0;
              format = "{:%A %d %B}";
            };
          };
          "lockscreen-widget-0000000000000004" = {
            box_height = 96.0;
            box_width = 416.0;
            cx = 1280.0;
            cy = 640.0;
            output = "DP-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background_opacity = 0.0;
              background_padding = 0;
              background_radius = 0;
              format = "{:%A %d %B}";
            };
          };
        };
      };

      notification = {
        background_opacity = 0.7;
        layer = "overlay";
        offset_x = 5;
        offset_y = 5;
        position = "bottom_right";
      };

      osd = {
        background_opacity = 0.7;
        offset_x = 5;
        offset_y = 5;
      };

      shell = {
        avatar_path = "${toString ../assets/avatar.jpg}";
        clipboard_enabled = false;
        date_format = "%a, %x";
        font_family = "Monocraft";
        niri_overview_type_to_launch_enabled = true;
        polkit_agent = true;
        screen_time_enabled = true;
        telemetry_enabled = true;
        time_format = "{:%H:%M:%S}";
        panel = {
          open_near_click_control_center = true;
        };
        shadow = {
          direction = "center";
        };
        launch_apps_as_systemd_services = true;
      };

      theme = {
        custom_palette = "050010";
        source = "custom";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };

      wallpaper = {
        enabled = false;
      };

      weather = {
        refresh_minutes = 45;
      };

      widget = {
        active_window = {
          icon_size = 16;
          max_length = 384;
          min_length = 384;
          show_empty_label = true;
          title_scroll = "on_hover";
        };
        bluetooth = {
          show_label = true;
        };
        clock = {
          anchor = true;
          format = "{:%H:%M:%S %a}";
          tooltip_format = "{:%H:%M:%S %a, %d %B %Y}";
          vertical_format = "{:%d %m}";
        };
        cpu = {
          display = "text";
        };
        media = {
          max_length = 256;
          min_length = 256;
          title_scroll = "on_hover";
        };
        ram = {
          display = "text";
        };
        workspaces = {
          font_weight = 900;
          scale = 1.3;
        };
      };
    };
  };

  home.file.".config/noctalia/palettes/050010.json".source = "${cfg}/palettes/050010.json";
}
