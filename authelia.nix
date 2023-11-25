{ config, pkgs, ... }:

let
  authelia-extras = import ./authelia-extras.nix;
in
{
  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = "/var/lib/authelia-main/jwt-secret";
      storageEncryptionKeyFile = "/var/lib/authelia-main/storage-secret";
      sessionSecretFile = "/var/lib/authelia-main/session-secret";
    };
    settings = {
      theme = "dark";
      default_redirection_url = "https://wiki.sitblueprint.com";
  
      server = {
        host = "127.0.0.1";
        port = 9091;
      };
  
      log = {
        level = "info";
        format = "text";
      };
  
      authentication_backend = {
        refresh_interval = "always";
        file = {
          path = "/var/lib/authelia-main/users.yml";
          watch = true;
          search.email = true;
        };
      };
  
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = ["mesh.stag.sitblueprint.com"];
            policy = "one_factor";
	    subject = [
		["group:dev"]
	    ];
          }
          {
            domain = ["wiki.sitblueprint.com"];
            policy = "one_factor";
          }
          {
            domain = ["wiki.sitblueprint.com"];
            policy = "one_factor";
          }
          {
            domain = ["stag0.nyc.sitblueprint.com"];
            policy = "one_factor";
          }
        ];
      };
  
      session = {
        name = "authelia_session";
        expiration = "12h";
        inactivity = "45m";
        remember_me_duration = "1M";
        domain = "sitblueprint.com";
        redis.host = "/run/redis-authelia-main/redis.sock";
      };
  
      regulation = {
        max_retries = 3;
        find_time = "5m";
        ban_time = "15m";
      };
  
      storage = {
        local = {
          path = "/var/lib/authelia-main/db.sqlite3";
        };
      };

      notifier = {
        smtp = {
          host = "smtp.migadu.com";
          port = 587;
          username = "authelia@sitblueprint.com";
          password = (builtins.readFile /var/lib/authelia-main/smtp-pass);
          sender = "authelia <authelia@sitblueprint.com>";
          startup_check_address = "tianyu.zhu@sitblueprint.com";
        };
      };
    };
  };
  services.redis.servers.authelia-main = {
    enable = true;
    user = "authelia-main";   
    port = 0;
    unixSocket = "/run/redis-authelia-main/redis.sock";
    unixSocketPerm = 600;
  };
  services.nginx.virtualHosts."auth.stag0.nyc.sitblueprint.com" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:9091";
      proxyWebsockets = true;
      extraConfig = authelia-extras.proxy;
    };
    
  };
}
