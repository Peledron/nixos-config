{config, ...}: let
  userdata-basedir = "${config.home.homeDirectory}/Data";
in {
  # set the default user directory folders
  xdg = {
    userDirs = {
      enable = true;
      desktop = "${userdata-basedir}/Desktop";
      download = "${userdata-basedir}/Downloads";
      documents = "${userdata-basedir}/Documents";
      music = "${userdata-basedir}/Music";
      pictures = "${userdata-basedir}/Pictures";
      videos = "${userdata-basedir}/Videos";
      templates = "${userdata-basedir}/Templates";
      publicShare = "${userdata-basedir}/Public";

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "$XDG_PICTURES_DIR/screenshots/linux";
      };
    };
  };
  # then create them using systemd tempdirectories that do not auto-refresh, the - means no refresh
  # its "directory (d) foo/bar perms user group ttl"
  systemd.user.tmpfiles.rules = [
    "d ${userdata-basedir} 0770 pengolodh users -"
    "d ${userdata-basedir}/Desktop 0750 pengolodh users -"
    "d ${userdata-basedir}/Downloads 0750 pengolodh users -"
    "d ${userdata-basedir}/Documents 0750 pengolodh users -"
    "d ${userdata-basedir}/Pictures 0750 pengolodh users -"
    "d ${userdata-basedir}/Music 0750 pengolodh users -"
    "d ${userdata-basedir}/Videos 0750 pengolodh users -"
    "d ${userdata-basedir}/Templates 0750 pengolodh users -"
    "d ${userdata-basedir}/Public 0750 pengolodh users -"
    "d ${userdata-basedir}/Pictures/screenshots/linux 0750 pengolodh users -"
  ];
}
