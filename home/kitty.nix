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
    };

    enableGitIntegration = true;

    shellIntegration.enableFishIntegration = true;
  };
}
