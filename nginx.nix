{
  services.nginx.enable = true;
  services.nginx.virtualHosts."stag0.nyc.sitblueprint.com" = {
    forceSSL = true;
    enableACME = true;
    root = "/var/www/";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "tianyu.zhu@sitblueprint.com";
  };
}
