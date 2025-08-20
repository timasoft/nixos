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
          provider = "duckduckgo";
          target = "_blank";
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
                icon = "https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/github.svg";
              }
            ];
          }
          {
            NixPkgs = [
              {
                abbr = "NP";
                href = "https://search.nixos.org/";
                icon = "https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/nixos.svg";
              }
            ];
          }
          {
            NixSearch = [
              {
                abbr = "NS";
                href = "https://mynixos.com/search/";
                description = "Search for NixOS options";
                icon = "https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/nixos.svg";
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
                icon = "https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/youtube.svg";
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
                icon = "https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/kinopoisk.svg";
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
                icon = "https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/reddit.svg";
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
    ];
  };
}
