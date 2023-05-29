{ config, ... }:
{   # see https://nixos.wiki/wiki/Git
    programs.git = {
        enable = true; # set git config to be managed by home-manager
        userName  = "pengolodh";
        userEmail = "lysander.deloore@gmail.com";
    };
}
