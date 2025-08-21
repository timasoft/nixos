{ config, pkgs, ... }:

let
  baseUrl = "http://10.1.1.195:8888";
  secret = builtins.hashString "sha256" (toString config.networking.hostId);
in
{
  services.searx = {
    enable = true;
    package = pkgs.searxng;

    redisCreateLocally = true;

    runInUwsgi = false;

    settings = {
      server = {
        bind_address = "0.0.0.0";
        port = 8888;
        base_url = baseUrl;
        public_instance = false;
        image_proxy = true;
        secret_key = secret;
      };

      general = {
        instance_name = "searxng-local";
        enable_metrics = false;
      };

      search = {
        formats = [ "html" "json" "rss" ];
        autocomplete = "duckduckgo";
      };
    };
  };
}

