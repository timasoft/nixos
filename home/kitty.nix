{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "Monocraft Nerd Font";
      font_size = 11;
      scrollback_lines = -1;
      enable_audio_bell = false;
      background = "#050010";
      foreground = "#ddffff";
      background_opacity = 0.95;
      window_padding_width = 3;
    };

    enableGitIntegration = true;

    shellIntegration.enableFishIntegration = true;
  };
}
