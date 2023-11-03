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
		locations."/" = {
			proxyPass = "http://localhost:80";
		};
	};
}
