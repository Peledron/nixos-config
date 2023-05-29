# user-specific config

{ config, lib, pkgs, ... }:
{
   services.xserver.displayManager = {
         autoLogin.enable = true;
         autoLogin.user = "pengolodh";
   };
   users = {
      #users.mutableUsers = false;
      # --> false makes it so that nix manages users entirely, users are no longer addable with useradd and passwords are stored on a per user basis instead of /etc/passwd ==> if a user is deleted from the config it is gone entirely from that itteration
      # --> true is the default user management

      users = {
         # Define a user account. Don't forget to set a password with ‘passwd’. or run mkpasswd and copy the hash in hashedPassword = "";
         # place new users here:
         # user pengolodh
         pengolodh = {
            isNormalUser = true;
            home = "/home/pengolodh" ; # you can define a different home, /home/$USER is used by default
            # passwordFile = "/path/to/password.txt"; # you can store a password hash in $flakedir/.secrets and encrypt/decrypt it with git-crypt 
            # hashedPassword = ""; # password hash generated via mkpasswd
            initialPassword = "changeme"; # change this with passwd on login
            extraGroups = [ "wheel" "docker" "kvm" "libvirtd" ]; # add user to groups for extra permissions like sudo access

            /*
            # ssh user specific settings:
            openssh = {
               # set ssh authorized keys
               authorizedKeys = {
                  keys = [

                  ];
               };
            };
            */
            # sddm autologin

         };
         # add new users here:
      };
   };

}
