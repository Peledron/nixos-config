# user-specific config

{ config, lib, pkgs, ... }:
{
   # sddm autologin (or gdm i think)
   services.xserver.displayManager = {
         autoLogin.enable = true;
         autoLogin.user = "pengolodh";
   };

}
