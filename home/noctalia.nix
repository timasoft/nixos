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
          "lockscreen-clock-time@DP-1"
          "lockscreen-clock-time@DVI-D-1"
          "lockscreen-clock-date@DP-1"
          "lockscreen-clock-date@DVI-D-1"
        ];
        grid = {
          cell_size = 8;
          major_interval = 4;
          visible = true;
        };
        widget = let
          # Outputs and their scale factors relative to the 640x360 universal grid
          outputs = {
            "DP-1" = 4.0;    # 2560x1440
            "DVI-D-1" = 3.0; # 1920x1080
          };

          # Base widgets defined on the 640x360 grid
          baseWidgets = [
            {
              id = "login-box";
              type = "login_box";
              box_height = 52.0;
              box_width = 240.0;
              cx = 320.0;
              cy = 180.0;
              settings = {
                background_color = "surface_variant";
                background_opacity = 0.0;
                background_radius = 12.0;
                center_password_text = true;
                input_opacity = 0.7;
                input_radius = 10.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = false;
                show_login_button = false;
                show_session_buttons = false;
              };
            }
            {
              id = "clock-time";
              type = "clock";
              box_height = 24.0;
              box_width = 92.0;
              cx = 320.0;
              cy = 120.0;
              settings = {
                background_opacity = 0.0;
                background_padding = 0;
                background_radius = 0;
                format = "{:%T}";
              };
            }
            {
              id = "clock-date";
              type = "clock";
              box_height = 24.0;
              box_width = 109.0;
              cx = 320.0;
              cy = 140.0;
              settings = {
                background_opacity = 0.0;
                background_padding = 0;
                background_radius = 0;
                format = "{:%A %d %B}";
              };
            }
          ];

          # Helper to scale spatial attributes (cx, cy, width, height)
          scaleWidget = scale: widget:
            let
              scaleAttr = name: value:
                if builtins.elem name [ "box_height" "box_width" "cx" "cy" ]
                then value * scale
                else value;
            in builtins.mapAttrs scaleAttr widget;

          # Generate final widgets for all outputs
          mkWidgets = builtins.concatMap (outputName:
            let
              scale = outputs.${outputName};
            in
            map (base:
              let
                # Remove 'id' before scaling, as it's not a spatial attribute
                spatial = builtins.removeAttrs base [ "id" ];
                scaled = scaleWidget scale spatial;

                finalName = "lockscreen-${base.id}@${outputName}";
              in
              {
                name = finalName;
                value = scaled // {
                  output = outputName;
                  rotation = 0.0;
                };
              }
            ) baseWidgets
          ) (builtins.attrNames outputs);

        in builtins.listToAttrs mkWidgets;
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
          visualization = "none";
        };
        media = {
          max_length = 256;
          min_length = 256;
          title_scroll = "on_hover";
        };
        ram = {
          visualization = "none";
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
