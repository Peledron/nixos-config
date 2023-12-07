# user-specific config

{ config, lib, pkgs, self, ... }:
/*let
   passwd-dir = "${self}/.secrets/passwd" # self refers to the base directory of the flake
in*/
{

   users = {
      users = {
         # Define a user account. Don't forget to set a password with ‘passwd’. or run mkpasswd and copy the hash in hashedPassword = "";
         # place new users here:
         # user pengolodh
         pengolodh = {
            isNormalUser = true;
            home = "/home/pengolodh" ; # you can define a different home, /home/$USER is used by default
            #passwordFile = "${passwd-dir}/pengolodh/passwd"; # you can store a password hash in $flakedir/.secrets and encrypt/decrypt it with git-crypt
            hashedPassword = "$6$iloR4OWTUPzS1jPM$OsIp0yHs9IT.NB1PKfVvC8WlJqv5EuHPGq/czcaBh05bJael9Qc5e1OM2oUrE11/2spcdaIfUv9rZNVrbZzTY."; # password hash generated via mkpasswd -m sha-512
            #initialPassword = "changeme"; # change this with passwd on login
            extraGroups = [ "wheel" "docker" "kvm" "libvirtd" "video" ]; # add user to groups for extra permissions like sudo access


            # ssh user specific settings:
            openssh = {
               # set ssh authorized keys
               authorizedKeys = {
                  keys = [
                     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN2Ic51w68EFuVfoqvWo3xbZCYYyAdt2Mj4u6ZXh2pP" #nixos-pengolodh, stored in gitlab.com/pengolodh/dotfiles -> ssh/.ssh/home => its encrypted with git crypt using a gpg key
                  ];
               };
            };

         };
         # add new users here:
      };
   };

}
