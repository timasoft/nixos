{ config, unstable, ... }:

{
  home.packages = [ unstable.herdr ];

  programs.herdr = {
    enable = true;

    package = unstable.herdr;

    settings = {
      onboarding = false;

      theme = {
        name = "terminal";
        auto_switch = false;
      };

      terminal.kitty_graphics = true;

      update.version_check = false;

      ui = {
        sidebar_start_collapsed = true;
        right_click_passthrough_modifier = "alt";
        prompt_new_workspace_name = true;
        window_title = "herdr: {terminal_title}";
        status_indicators = "symbols";

        toast.delivery = "terminal";
        sound.enabled = true;
      };
    };
  };
}
