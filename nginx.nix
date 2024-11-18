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
			proxyPass = "http://10.10.1.2:8080";
			extraConfig = authelia-extras.authelia-auth;
		};
	};
	services.nginx.virtualHosts."admin.api.sitblueprint.com" = {
		forceSSL = true;
		enableACME = true;
		extraConfig = authelia-extras.authelia-location;
		locations."/" = {
			proxyPass = "http://10.10.1.2:8081";
			extraConfig = authelia-extras.authelia-auth;
		};
	};
	services.nginx.virtualHosts."admin.sitblueprint.com" = {
		forceSSL = true;
		enableACME = true;
		extraConfig = authelia-extras.authelia-location;
		locations."/" = {
			proxyPass = "http://10.10.1.3:80";
			extraConfig = authelia-extras.authelia-auth;
		};
	};
	services.nginx.virtualHosts."aad.stag.sitblueprint.com" = {
		forceSSL = true;
		enableACME = true;
		extraConfig = authelia-extras.authelia-location;
		locations."/" = {
			proxyPass = "http://10.10.2.3:3000";
			extraConfig = authelia-extras.authelia-auth;
		};
	};
	security.acme = {
		acceptTerms = true;
		defaults.email = "ezri@sitblueprint.com";
	};
}
