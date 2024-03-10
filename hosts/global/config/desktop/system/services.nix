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
  xdg = lib.mkDefault {
    portal = {
      enable = true;
      xdgOpenUsePortal = true; # use the portal to open programs, which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers. from https://github.com/NixOS/nixpkgs/issues/160923, this fixed screencasting problem under hyprland (screeencasting opened window picker multible times)
      #config.common.default = "*";
    };
    mime.enable = true; # installs pkgs.shared-mime-info to support the XDG Shared MIME-info specification and the XDG MIME Applications specification (this is a list of default application associations when opening a file)
  };
  # power management
  # -> enables suspend to ram and such (is this needed?)
  powerManagement = lib.mkDefault {
    enable = true;
    powertop.enable = false; # enable powertop auto-optimize of tunetables (not needed with tlp enabled), is very aggressive with the usb autosuspend
  };

  # enable either auto-cpufreq or tlp, tlp has more features like drive suspend, however auto-cpufreq seems to be better for cpu management (cooler and less power to my testing)
  services.auto-cpufreq = lib.mkDefault {
    enable = true;
  };
  services.tlp = lib.mkDefault {
    enable = false;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0; # disallows turbo on battery
      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 1;

      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth wifi wwan";
      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholdshttps://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 90;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      CPU_MAX_PERF_ON_AC = 75; # limited to 75 to reduce fan noise
      CPU_MAX_PERF_ON_BAT = 50;
    };
  };
}
