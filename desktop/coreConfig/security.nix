{lib, ...}: {
  nm-overrides = {
    performance.no-pti.enable = true;
    desktop = {
      allow-multilib.enable = true;
      allow-unprivileged-userns.enable = true;
      #home-exec.enable = true;
      #tmp-exec.enable = true;
      usbguard-disable.enable = lib.mkDefault true;
      yama-relaxed.enable = true;
      #hideproc-relaxed.enable = true;
    };
  };
}
