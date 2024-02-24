# user-specific config

{ config, lib, pkgs, ... }:
{
   # pengolodh is created in global/users/pengolodh/usr.nix
   users.users.pengolodh.openssh = {
      # set ssh authorized keys
      authorizedKeys = {
         keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPk3nsMqW3510sd9kktNqfM3YuP1qUzTscNg0VWDEJX4" # nixos-server-key
         ];
      };
   };

}

