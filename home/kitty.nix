{
  programs.kitty = {
    enable = true;

    settings = {
      scrollback_lines = -1;
      enable_audio_bell = false;
      window_padding_width = 3;
      cursor_trail = 10;
      input_delay = 0;
      repaint_delay = 5;
      sync_to_monitor = false;
      bold_font = "postscript_name=Monocraft-Bold";
      italic_font = "postscript_name=Monocraft-Italic";
      bold_italic_font = "postscript_name=Monocraft-Bold-Italic";
    };

    enableGitIntegration = true;

    shellIntegration.enableFishIntegration = true;
  };
}
