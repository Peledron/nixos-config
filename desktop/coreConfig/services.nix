# important system services
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  # nice daemon
  services.ananicy = {
    package = pkgs.unstable.ananicy-cpp;
    enable = true;
    rulesProvider = pkgs.unstable.ananicy-rules-cachyos;
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
    enable = false; # disabled dont really use it
    # nssmdns4 = true; # unstable option
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
  };

  # enable either auto-cpufreq or tlp, tlp has more features like drive suspend, however auto-cpufreq seems to be better for cpu management (cooler and less power to my testing)
  services.auto-cpufreq = lib.mkDefault {
    enable = false;
  };

  # You can tell the Linux kernel to use an interpreter (e.g. appimage-run) when executing certain binary files through the use of binfmt_misc, either by filename extension or magic number matching. Below NixOS configuration registers AppImage files (ELF files with magic number "AI" + 0x02) to be run with appimage-run as interpreter.
  # -> https://nixos.wiki/wiki/Appimage
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
}
