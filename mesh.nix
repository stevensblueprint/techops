{ pkgs, ... }:
let
	authelia-extras = import ./authelia-extras.nix;
in
{
	services.nginx.virtualHosts."mesh.stag.sitblueprint.com" = {
		forceSSL = true;
		enableACME = true;
                extraConfig = authelia-extras.authelia-location;
		locations."/" = {
			proxyPass = "http://localhost:3000";
                        extraConfig = authelia-extras.authelia-auth;
		};
	};
}
