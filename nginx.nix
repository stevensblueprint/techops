let
authelia-extras = import ./authelia-extras.nix;
in
{
	services.nginx.enable = true;
	services.nginx.virtualHosts."stag0.nyc.sitblueprint.com" = {
		forceSSL = true;
		enableACME = true;
		root = "/var/www/";
	};
	services.nginx.virtualHosts."auth.api.sitblueprint.com" = {
		forceSSL = true;
		enableACME = true;
		extraConfig = authelia-extras.authelia-location;
		locations."/" = {
			proxyPass = "http://172.17.0.1:8080";
			extraConfig = authelia-extras.authelia-auth;
		};
	};
	security.acme = {
		acceptTerms = true;
		defaults.email = "ezri@sitblueprint.com";
	};
}
