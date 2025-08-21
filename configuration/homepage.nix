{
  services.nginx.enable = true;

  services.nginx.virtualHosts."homepage.local" = {
    listen = [ { addr = "0.0.0.0"; port = 80; } ];

    locations."/".proxyPass = "http://127.0.0.1:8082";
  };

  services.homepage-dashboard = {
    enable = true;

    allowedHosts = "localhost:8082,127.0.0.1:8082,10.1.1.195:8082";

    listenPort = 8082;

    customCSS = ''
      body, html {
        font-family: Monocraft, sans-serif !important;
      }
    '';

    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
      {
        search = {
          provider = "custom";
          url = "http://10.1.1.195:8888/search?q=";
          target = "_blank";
          suggestionUrl = "http://10.1.1.195:8888/autocompleter?type=list&q=";
          showSearchSuggestions = true;
        };
      }
    ];

    bookmarks = [
      {
        Dev = [
          {
            GitHub = [
              {
                abbr = "GH";
                href = "https://github.com/";
                icon = "https://cdn.simpleicons.org/github";
              }
            ];
          }
          {
            NixPkgs = [
              {
                abbr = "NP";
                href = "https://search.nixos.org/";
                icon = "https://cdn.simpleicons.org/nixos";
              }
            ];
          }
          {
            NixSearch = [
              {
                abbr = "NS";
                href = "https://mynixos.com/search/";
                description = "Search for NixOS options";
                icon = "https://cdn.simpleicons.org/nixos";
              }
            ];
          }
          {
            SimpleIcons = [
              {
                abbr = "SI";
                href = "https://simpleicons.org/";
                description = "Search for simple icons";
                icon = "https://cdn.simpleicons.org/simpleicons";
              }
            ];
          }
        ];
      }
      {
        Entertainment = [
          {
            YouTube = [
              {
                abbr = "YT";
                href = "https://www.youtube.com/";
                icon = "https://cdn.simpleicons.org/youtube";
              }
            ];
          }
          {
            AnimeGO = [
              {
                abbr = "Ani";
                href = "https://animego.me/";
                icon = "https://animego.me/favicon.ico";
              }
            ];
          }
          {
            KinoPoisk = [
              {
                abbr = "KP";
                href = "https://hd.kinopoisk.ru/";
                icon = "https://cdn.simpleicons.org/kinopoisk";
              }
            ];
          }
        ];
      }
      {
        Social = [
          {
            Reddit = [
              {
                abbr = "RE";
                href = "https://www.reddit.com/";
                icon = "https://cdn.simpleicons.org/reddit";
              }
            ];
          }
        ];
      }
    ];

    services = [
      {
        "AI" = [
          {
            "Open Web-UI" = {
              description = "Chat with AI";
              href = "http://10.1.1.195:8080";
              icon = "https://cdn.jsdelivr.net/gh/open-webui/open-webui@master/static/favicon.png";
            };
          }
          {
            "ComfyUI" = {
              description = "Needs manual start";
              href = "http://10.1.1.195:8188";
            };
          }
        ];
      }
      {
        "Search" = [
          {
            "SearXNG" = {
              description = "Powerful search";
              href = "http://10.1.1.195:8888";
              icon = "https://cdn.simpleicons.org/searxng";
            };
          }
        ];
      }
    ];
  };
}
