{lib, ...}: {
  nix-mineral.overrides = {
    performance.no-pti = true;
    desktop = {
      allow-multilib = true; # needed for steam (allows 32bit)
      allow-unprivileged-userns = true;
      disable-usbguard = lib.mkDefault true;
      yama-relaxed = true;
    };
  };
}
