{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting ""
      pfetch
      zoxide init fish | source

      function y
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
      end
    '';
    loginShellInit = ''
      if not contains $HOME/.local/bin $fish_user_paths
        set -U fish_user_paths $HOME/.local/bin $fish_user_paths
      end
    '';
    shellAliases = {
      ls = "eza";
    };
  };
}
