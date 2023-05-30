{ config, lib, pkgs, system, imputs, ... }:
{
    xdg.userDirs = {
        enable = true;
        desktop = "${config.home.homeDirectory}/Data/Desktop";
        download = "${config.home.homeDirectory}/Data/Downloads";
        documents = "${config.home.homeDirectory}/Data/Documents";
        music = "${config.home.homeDirectory}/Data/Music";
        pictures = "${config.home.homeDirectory}/Data/Pictures";
        videos = "${config.home.homeDirectory}/Data/Videos";
        templates = "${config.home.homeDirectory}/Data/Templates";
        publicShare = "${config.home.homeDirectory}/Data/Public";

        extraConfig = {
            XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Data/$XDG_PICTURES_DIR/screenshots/linux";
        };

    };
}
