{lib, ...}: {
  nm-overrides = {
    desktop = {
      allow-multilib.enable = true;
      allow-unprivileged-userns.enable = true;
      home-exec.enable = true;
      tmp-exec.enable = true;
      usbguard-disable.enable = lib.mkDefault true;
      yama-relaxed.enable = true;
    };
  };
}
