{ pkgs, lib, ... }:
let
authelia-extras = import ./authelia-extras.nix;
in
{
	services.vaultwarden = {
		enable = true;
		backupDir = "/var/lib/vaultwarden/backup";
		environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
		config = {
			DOMAIN = "https://vault.sitblueprint.com";
			SIGNUPS_ALLOWED = false;
			ROCKET_ADDRESS = "127.0.0.1";
			ROCKET_PORT = 8222;
		};
	};
	services.nginx.virtualHosts."vault.sitblueprint.com" = {
		forceSSL = true;
		enableACME = true;
		extraConfig = authelia-extras.authelia-location;
		locations."/" = {
			proxyPass = "http://127.0.0.1:8222";
			extraConfig = authelia-extras.authelia-auth;
		};
	};
}
