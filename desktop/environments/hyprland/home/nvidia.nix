{pkgs, ...}: {
  hardware.nvidia.modesetting.enable = true; # for wayland support (kms)
  programs.hyprland.nvidiaPatches = true;

  # nvidia/wayland specific environment vars:
  environment.sessionVariables = {
    # [wlroots specific]
    WLR_DRM_NO_ATOMIC = "1";
    WLR_NO_HARDWARE_CURSORS = "1";

    GBM_BACKEND = "nvidia-drm"; # nvidia gbm support
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # --> video accel
    VDPAU_DRIVER = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia"; # --> hardware accell support foor vaapi

    # --> if using firefox:
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1"; # disable when not used as rdd sandbox increases security
  }; # for more nvidia specific things see hosts/${host}/core/hardware.nix

  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver # --> hardware video acceleration, dont forget to modify firefox settings according to: https://github.com/elFarto/nvidia-vaapi-driver
  ];
}
