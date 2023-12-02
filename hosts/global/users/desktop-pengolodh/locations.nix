{ config, lib, pkgs, system, imputs, ... }:
{
    # set the default user directory folders
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
    # then create them using systemd tempdirectories that do not auto-refresh, the - means no refresh
    # its "directory (d) foo/bar perms user group ttl"
    systemd.tmpfiles.rules = [
        "d ${config.home.homeDirectory}/Data 0770 pengolodh users -"
        "d ${config.home.homeDirectory}/Data/Desktop 0750 pengolodh users -"
        "d ${config.home.homeDirectory}/Data/Downloads 0750 pengolodh users -"
        "d ${config.home.homeDirectory}/Data/Documents 0750 pengolodh users -"
        "d ${config.home.homeDirectory}/Data/Pictures 0750 pengolodh users -"
        "d ${config.home.homeDirectory}/Data/Music 0750 pengolodh users -"
        "d ${config.home.homeDirectory}/Data/Videos 0750 pengolodh users -"
        "d ${config.home.homeDirectory}/Data/Templates 0750 pengolodh users -"
        "d ${config.home.homeDirectory}/Data/Public 0750 pengolodh users -"
        "d ${config.home.homeDirectory}/Data/Pictures/screenshots/linux 0750 pengolodh users -"
    ];
}
