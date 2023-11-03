let
  authelia-extras = import ./authelia-extras.nix;
in
{
	services.dokuwiki.sites."localhost" = {
		enable = true;
		settings = {
			title = "Blueprint Wiki";
			useacl = true;
			baseurl = "https://wiki.sitblueprint.com"; 
		};
	};
	services.nginx.virtualHosts."wiki.sitblueprint.com" = {
		forceSSL = true;
		enableACME = true;
                extraConfig = authelia-extras.authelia-location;
		locations."/" = {
			proxyPass = "http://localhost:80";
                        extraConfig = authelia-extras.authelia-auth;
		};
	};
}
