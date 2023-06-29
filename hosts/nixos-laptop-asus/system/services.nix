# important system services

{ config, lib, pkgs, ... }:
{
  # zfs autotrim 
  services.zfs.trim.enable = true;
  # nice daemon
  # --> need to see if there is an easy way to input large rulesets like https://github.com/CachyOS/ananicy-rules
  services.ananicy = {
    package = pkgs.ananicy-cpp;
    enable = true;
    #extraRules = {}; # for extra rules --> list would be too large to import things like community rulesets, the default ruleset from ananicy is imported
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
  # --> pulseaudio:
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # ----

  # printing
  # --> printer discovery:
  services.avahi = {                                   # Needed to find wireless printer
    enable = true;
    nssmdns = true;
    publish = {                               # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
    };
  };
  # --> CUPS:
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip pkgs.hplipWithPlugin ]; # hplip == hp printer drivers; hplipWithPlugin == additional hp drivers
  }; 
  # --> scanning:
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ]; # see above
  };
  # ----

  # flatpak 
  # --> best used for non-native or closed sourced apps like discord, obsidian, ... (better isolation than nixos packages)
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  # --> see ./desktop.nix for xdg portal as it is dependant on de (kde and gnome auto-install their respective portals)
  # ---

  # virtualisation
  virtualisation = {
    #  --> libvirt:
    libvirtd = {
      enable = true;
    };
    #  --> docker:
    docker ={
      enable = true;
    };
  };
  # ----

  # power management
  # -> enables suspend to ram and such (is this needed?)
  #services.auto-cpufreq.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT="powersave";
      CPU_SCALING_GOVERNOR_ON_AC="performance";
      CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power";
      CPU_BOOST_ON_AC=1;
      CPU_BOOST_ON_BAT=0; # disallows turbo on battery
      SCHED_POWERSAVE_ON_AC=0;
      SCHED_POWERSAVE_ON_BAT=1;


      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth wifi wwan";
      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholdshttps://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0=40;
      STOP_CHARGE_THRESH_BAT0=90;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      CPU_MAX_PERF_ON_AC=75; # limited to 75 to reduce fan noise
      CPU_MAX_PERF_ON_BAT=50;
    };
  };
  powerManagement = {
    enable = true;
    #powertop.enable = true; # enable powertop auto-optimize of tunetables (not needed with tlp enabled)
  };

}
