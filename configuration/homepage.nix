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
          {
            "SearXNG Settings" = {
              description = "Load settings for SearXNG";
              href = "http://10.1.1.195:8888/preferences?preferences=eJx1WMuO67gR_Zp4I4wxyQ0SZOFVgNkmQGYvUGRJ4hXFUvNhW_31OdSTbPVd2LAOxWKxnqcsRaCOnSb_6MiSE-ZmhO2i6OghDB5YCkMPF28iBpY8ToYCPVSUQ_p0fGvFU0u2tSPP5knucdMjdteT4_f8-NNFuo0UelaP__7nf3_evGjJk3Cyf_x-Cz2N9PA6Sb1BQDTB15Bl6VUH0Tz-EMbTTbE-pbPA451dd1u31T7MULAxQg43STaQq4XRnR3xez1eqKewklS9nbtK_Yjk5lrbOugAASuobautDpAqHRuz7l-3Jb3kaq0ZkgzJTXzPYaDZPxS1Ahe4RWfqlt0oQtC2e0yOQphvSnvRGChBttMW5v7xj983wfVm-b_87d__6kRX156lFqYaSWkBUMg22rp-akXs07PihioPdwx1vRj7C1otr36_oxJRaayN0WuZlgy9hVVOi1wPYSYoWRlt47uaYNp0CA4Lac1a4aukuX5SXbfarOdbDxHw3PIwDdWonWOXvTDBXRW-kyKu2CkQQErs8l3QMr-YH3LVGqFVvADV-nq2bYUHodtd8EsPeko2LXbrIPsIj5_WAtQgtils-5qpKXYEpbvuVH9x011KeVe5FNlTO3ByLyPMXUIMR9Ua4UjoXKCcECMtOUKQbkci-rwHiFiQOuEr9lJPjdTI9s40fXm8WiKByS-Hd2R06bA536mIPpE6R1wo8kEE7U_1leoqxHjKD83W55uTMNzuGs_J5EqEMraWOBjFBBH4BoI8oZnyd_76zvTHkSr0IowoFjnsCDHNbXjBopXSDhmZcnO1YOu0HbTIA6mdZ3VepyP92SPpc8QG5m1_h6ogmt0drKgh151rBI_zuD8zKzhV5bKYO9xyMmKuRobXfBYavWicSF_b_h4JRm510QrQe_-1yNketKkm9uHwox676LILaiuyUxDrDr6a8xc-9KyzVwyN41zhImNMXk1Kfqk96xvRk_vVWtLoV2tJMoz6zbKGBdxcJY_7FGR7Mn3-ti2d0P4ut5BnO3SCPLgNNz7Q3e2mGwWqi2L7C52P5V74PojumzcoCDkJu8vTKRcRZZVBdB8of_ZFDo-vsTE5YFNTxCeztp32gLGzEFkBicY8hUJjLfIkgytY4FkkCKvZU15ueCJ7mG6PwgQ6gofOw9Zirv1e3FB6rml7gNdici6tR3-_rSg3U2xQGp_bgR9RuKKgL8D1oI-XsCF_z-muD5USnIPreePsU9POce44XoDrKSu8X-Ww5gq_SKLsnGVTKDXf92zZC82kf-vZ0AVfNUuVo0pfBzriWlpWXmKXcHmBR8F1YUrcKdM78DBzYN_zkGJyd2NI-kOGKC6Zo5vSs-iZy5LcFIX_xaZ1YkTH78vwm1FvUU-r4NDaDZiPKir0jx__fJ_6ePq0Yiz280-i4YpcfbDhRcxYxLsr8ikB170rfN16damLzdzRuNeJiciF2OQptFQAZM6QmuyLmmxpFmW3TM9XZVxEEcglGjAkj4zLsRc7ZfVwJumL33pgixSp_GzZzqnL7YtI8uHL_VboGskLfI1kuE8WeeSfXaoJ2VZ0vZCabLL4l2r4ZK0WFrhzKAwFPQxss-2pyY-gBWW6RScJxOpskWXaWjBstByw8O2yN7K_IMjXSy3oSk7T4XtV1W_2OSDcWz_zDGvAdKUYp5PmNBpFE5-C_tmuZIi2-4ZeJrTwy4JcVE0lGPHoc-aCYqhRBZDtOciJBFR93EkHge_pjLCcM1fB2w70qmO2dtErWytukeEvStngTg1QD37uDPrAwjwyOo_NgrZVjpPme3FojZZDTlSgvo7-9AII1XnvbqM85x03MnW534YX-m_Y5b4b_k3ZzakauGnWKzHCkUvZkHp5frB0WPF3vZPFPnaI2a4VB4HPkCoRYE_Bf7O0FId9QY-qOY34U6Pmn48DTCi8L2kRHbU5Nxec0T3LWq5OOvNexpDT9uhHg6adimLoRS_YHxC7Arz6vMBptX0NzR3eFdtIUK6DShGXbATliCiA9u_cf1KpBp_7JozTmLT3VZ0GevJ5okwpBDPPLs_35TrnrSadXNSIjEdOjNz3IdW596nUqn-leBTariF2zrbnmbEZ06GZnvO0l5mFqZRRuELfc5pvWpPASA6Oxy-fj2AwvNLhUpIdYVx151mOQ0iTC6KVyeetY9Ji53YZs4mogWUIgHjIgVGlWsOvvXb6ITbRhrgTl4hxIvojUJT2Mnp_n-bQ8x5dB4P50rEO-Nq1MEmNmc5stMIU59ap4WA7RWZE65Gsvs9H3MRyykNnjl_6-4EcM67QBtUrxW722lOPxZ8nqaE0zIP_OtgWxyXgI3KZiQlcO-EFnUgu89Yv4DPQACcFC16fXk1NZWGbpYQnz18YZEITOUWC3i_2zxcvcZkvfvnbKF9avHQ6S2kZPtlS2aVUogy7_stEPGnDIfPq-7U03lO1ENxdZ7vmOI4ms8JlKFqA6x1X-HK7FS6ciJp6TpJN-Hv2L880dPeOszkGjIfQBzAYroxjJTHH33yTiajy_sGiXv-_fIHu0EK2XC17kkP67ZbJv05_GTp012dGg3YBUhgZUeJ5DX0UBDQjvBgWG6Qxdnt1SXnT1tq2fMPYgGL7-D9aNT5g";
              icon = "https://cdn.simpleicons.org/searxng";
            };
          }
        ];
      }
    ];
  };
}
