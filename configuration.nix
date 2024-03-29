# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

let 
  env = import ./envvars.nix;
in 
{
  imports =
    [
      ./hardware-configuration.nix
      ./authelia.nix
      ./nginx.nix
      #./dokuwiki.nix
      ./bookstacks.nix
      ./mesh.nix
#      ./team-1.nix
      ./vaultwarden.nix
    ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "stag0";
    search = ["nyc.sitblueprint.com"];
    nameservers = [ "9.9.9.10" "149.112.112.10" ];
    dhcpcd.enable = false;
    interfaces = {
      ens18.ipv4.addresses = [{
          address = "198.8.59.36";
          prefixLength = 27;
      }];
    };
    defaultGateway = {
      address = "198.8.59.33";
      interface = "ens18";
    };
    firewall.allowedTCPPorts = [ 80 443 22 ];
  };
    
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  users.users.ezri = {
     isNormalUser = true;
     extraGroups = [ "wheel" ];
     openssh.authorizedKeys.keys  = [
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN2whKHD8XCH+CQwnagH+iBfkyjc/2f/QEfdsEi0SaKO <ssh://eric@eric.si|ed25519>"
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdN4a3yJUlKIaVezOe4hE8fRK9DkGSzwoZ9vfpsBsHh ide0sn3.sn3.bns.sh"
     ];
   };
  users.users.mmerlin = {
     isNormalUser = true;
     extraGroups = [ "wheel" ];
     openssh.authorizedKeys.keys  = [
       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/Es8RVItSr1Y9Cn+ieWsGE6CizFJKg+96lhXnWqfQX+E76m8uu+jFOXZVCKIyLdGi2HKhV/TMwVkIx5sWz/JcODyHIaiHvWFjMktjTUF8FHlTyAN4tCgp0laxtA0itqUkxhq1KZ/ITPfHi0lQ6BKPg3k2PDBgOBUXWcz2NJOZIZbehIwaT9MROjhShy1nVyA/qDik+wQ5BUeIyITzbUA1mX1RR97x6/CAAXAvBpnKxA86C19SPEONnS4wjVwEKFTGZbtjXmdJyFzp1CS6lDL6O4vLKem1Pgu0J+PxL/HdOVy5hEeqw3t9d9+1vrv/VylMYS0OompglaZGwyFNdRzwW9JgP/DQQLYiIHFxkziOrOnxcVC7nEY4PjFimJKd72gcmzsNJLA1cw1zR+Vg+6T9tpngmdpvC9CcQxquNHlqhpdrv0VFMXO0p8TNDM57zZmYriYAwSKl7mX/XlXO1EExz51t1yZ07xj/lhQ5muRQEpdpkol6E5X1HqQvcV74Q0aOoV4uf1S9Oo1nsLzT1/o21MLu68iVrVRqdzVC72gPuU50cT6C4YZMWkFYhE+ftee6lC9xL/4azGmMClQYP9SKyxOvUVD7+VFDtKOq8Ui/K2YvlfVSQ/eVKVNjmLYy7TSe6MnnFRE0dKFXdWq71AR/F92mtZBDP+r5xpwclp0wRw== mmerlin@stevens.edu"
     ];
   };
  users.users.docker = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" ];
   };
  users.users.danielyu = {
     isNormalUser = true;
     extraGroups = [ "wheel" ];
     openssh.authorizedKeys.keys  = [
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2KV7+4O510riEW8lMKhHaP3EpgVweOn97oXS2ezz4S blueprint"
     ];
   };
   users.users.bertant = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL46ymjUob4hpUDqS8n/ktjep/yRjkE9JweDi4zKyQURfqNjLwSFc6q1i43TeZBWB2/9YF39b5fGvXCacppmHHk="
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGuH1Ha5WEbBv0SgoTziFJJZDY25w95qRIIGa3QcUfX+rBjc0vNgt0hKka6B0w79ThY4PJqB7l5C4rkX6OveQv8="
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJsrjxcDUv1iZuXlnclwP63Dj54Z52dG7UGFlQ2wOoG6pluuXkQ9n6GDlumulr48QU/bbWopIszC0+J9rSw49Mo="
    ];
   };
   environment.systemPackages = with pkgs; [
     vim
     wget
     curl
     docker-compose
     htop
     croc
     tmux
     openssl
     git
   ];
  virtualisation = {
    docker = {
      enable = true;
    };
  };
  services.openssh.enable = true;
  system.stateVersion = "23.05";
  swapDevices = [ {
    device = "/swapfile";
    size = 4*1024;
    randomEncryption.enable = true;
  } ];
}
