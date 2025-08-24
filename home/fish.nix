{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting ""
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
    shellAliases = {
      ls = "eza";
    };
  };
}
