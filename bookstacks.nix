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
		nginx = {
			enableACME = true;
			forceSSL = true;
		};
	};
}
