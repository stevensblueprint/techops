{ pkgs, ... }:
let
	authelia-extras = import ./authelia-extras.nix;
	dokuwiki-template-Bootstrap3 = pkgs.stdenv.mkDerivation rec {
		name = "Bootstrap3";
		src = pkgs.fetchzip {
			url = "https://github.com/giterlizzi/dokuwiki-template-bootstrap3/archive/refs/heads/master.zip";
			hash = "sha256-Xj3fKeOk+ALI2yTZiExhe3Lqc+VFzQBBRJTKqpVdBx8=";
		};
		installPhase = "mkdir -p $out; cp -R * $out/";
	};
	plugin-AuthRemoteUser = pkgs.stdenv.mkDerivation rec {
		name = "AuthRemoteUser";
		src = pkgs.fetchzip {
			url = "https://codeberg.org/Charly/AuthRemoteUser/archive/master.zip";
			hash = "sha256-uHDpcwTKZSDu6A7sRr4UIjx2PoyEYk8DqnmL8MdMcCw=";
		};
		installPhase = "mkdir -p $out; cp -R * $out/";
	};
in
{
	services.dokuwiki.sites."localhost" = {
		enable = true;
		templates = [ dokuwiki-template-Bootstrap3 ];
		settings = {
			title = "Blueprint Wiki";
			useacl = true;
			baseurl = "https://wiki.sitblueprint.com";
			# template = "Bootstrap3"; 
		};
		plugins = [ plugin-AuthRemoteUser ];
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
