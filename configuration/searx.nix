{ config, unstable, ... }:

let
  baseUrl = "http://0.0.0.0:8888";
  secret = builtins.hashString "sha256" (toString config.networking.hostId);
in
{
  services.searx = {
    enable = true;
    package = unstable.searxng;

    redisCreateLocally = true;

    configureUwsgi = false;

    settings = {
      server = {
        bind_address = "0.0.0.0";
        port = 8888;
        base_url = baseUrl;
        public_instance = false;
        image_proxy = true;
        secret_key = secret;
        limiter = false;
      };

      general = {
        instance_name = "searxng-local";
        enable_metrics = false;
      };

      search = {
        formats = [ "html" "json" "rss" ];
        autocomplete = "duckduckgo";
      };

      engines = [
        { name = "bing"; categories = [ "general" ]; disabled = false; }
        { name = "wikipedia"; categories = [ "general" ]; disabled = false; }
        { name = "wikidata"; categories = [ "general" ]; disabled = false; }
        { name = "duckduckgo"; categories = [ "general" ]; disabled = false; }

        { name = "brave"; disabled = true; }
        { name = "startpage"; disabled = true; }
      ];
    };
  };
}
