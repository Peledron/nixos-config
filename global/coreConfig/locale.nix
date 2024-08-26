# timezones, localesettings that are globally true across all hosts
{pkgs, ...}: {
  # Set your time zone.
  time.timeZone = "Europe/Brussels";
  # ---

  # change locale settings
  # --> en_US for language, nl_BE for everything else
  i18n = {
    defaultLocale = "en_US.UTF-8"; # language
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "nl_BE.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_NUMERIC = "nl_BE.UTF-8";
      LC_TIME = "nl_BE.UTF-8";
      LC_MONETARY = "nl_BE.UTF-8";
      LC_PAPER = "nl_BE.UTF-8";
      LC_NAME = "nl_BE.UTF-8";
      LC_ADDRESS = "nl_BE.UTF-8";
      LC_TELEPHONE = "nl_BE.UTF-8";
      LC_MEASUREMENT = "nl_BE.UTF-8";
      LC_IDENTIFICATION = "nl_BE.UTF-8";
    };
  };
  # ---
  console = {
    # was moved from i18n to its own function
    earlySetup = true; # Enable setting virtual console options as early as possible (in initrd).
    packages = with pkgs; [terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz"; # tty font
    keyMap = "us"; # tty keymap (us-qwerty in this case) override this with console.useXkbConfig = true; to use the same as xorg in your host locale.nix
  };
  # ---
  # change keyboard layout
  # --> unsure if this affects DE
  #console.useXkbConfig = true; # overrides console settings set in global/locale.nix
  #services.xserver.layout = "us";
  # --> change other xkb settings:
  #services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  #};
  # ---
}
