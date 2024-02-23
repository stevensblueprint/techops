{ pkgs, lib, ... }:
let
authelia-extras = import ./authelia-extras.nix;
in
{
	services.bookstack = {
		enable = true;
		hostname = "wiki.sitblueprint.com";
		appKeyFile = "/var/lib/bookstack/bookstack-appkey";
		database.createLocally = true;
		mail = {
			host = "smtp.migadu.com";
			port = 587;
			user = "wiki@sitblueprint.com";
			passwordFile = "/var/lib/bookstack/smtp-pass";
			from = "wiki@sitblueprint.com";
			fromName = "BlueprintWiki";
		};
		nginx = {
			enableACME = true;
			forceSSL = true;
		};
	};
}
