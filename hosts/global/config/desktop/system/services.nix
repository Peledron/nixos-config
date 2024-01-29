# important system services
{
  config,
  lib,
  pkgs,
  ...
}: {
  # nice daemon
  services.ananicy = {
    package = pkgs.ananicy-cpp;
    enable = true;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };
  # ---

  # sound
  # --> pipewire:
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # printing
  # --> printer discovery:
  services.avahi = {
    # Needed to find wireless printer
    enable = true; # disabled dont really use it
    nssmdns4 = true;
    publish = {
      # Needed for detecting the scanner
      enable = true;
      addresses = true;
      userServices = true;
    };
  };
  # --> CUPS:
  services.printing = {
    enable = true;
    drivers = []; #pkgs.hplip pkgs.hplipWithPlugin ]; # hplip == hp printer drivers; hplipWithPlugin == additional hp drivers, these need to compile so i have disabled them, most printer should work without them anyway
  };
  # --> scanning:
  hardware.sane = {
    enable = true;
    extraBackends = []; #pkgs.hplipWithPlugin ]; # see above
  };
  # ----

  # flatpak
  # --> best used for non-native or closed sourced apps like discord, obsidian, ... (better isolation than nixos packages)
  services.flatpak.enable = true;
  xdg.portal.enable = lib.mkDefault true;

  # power management
  # -> enables suspend to ram and such (is this needed?)
  powerManagement = lib.mkDefault {
    enable = true;
    powertop.enable = false; # enable powertop auto-optimize of tunetables (not needed with tlp enabled), is very aggressive with the usb autosuspend
  };

  services.auto-cpufreq = lib.mkDefault {
    enable = true;
  };
}
