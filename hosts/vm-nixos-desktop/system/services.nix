# important system services

{ config, lib, pkgs, ... }:
{
  # ssh is enabled globally, you can override  its settings, or disable it here:
  /*
  services.openssh = {
    enable = true;
    settings = {
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false; # Change to false to disable s/key passwords
      permitRootLogin = "no";
    };
    ports = [ 22001 ];
  };
  */
  #---

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

}
