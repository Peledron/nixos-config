# timezones, localesettings that are globally true across all hosts
{ config, lib, pkgs, ... }:
{
  # Set your time zone.
  time.timeZone = "Europe/Brussels";
  # ---

  # change locale settings
  # --> en_US for language, nl_BE for everything else
  i18n = {
    defaultLocale = "en_US.UTF-8"; # language

    extraLocaleSettings = {
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
  console = { # was moved from i18n to its own function
    earlySetup = true
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz"; # tty font
    keyMap = "us"; # tty keymap (us-qwerty in this case) override this with console.useXkbConfig = true; to use the same as xorg in your host locale.nix
  };
  # ---
}
