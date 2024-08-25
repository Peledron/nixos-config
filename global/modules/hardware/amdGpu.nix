{
  config,
  pkgs,
  lib,
  extraVar,
  ...
}: {
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];
  hardware = {
    # vulkan settings
    opengl = {
      enable = true;
      # enable vulkan drivers:
      driSupport = true;
      driSupport32Bit = true; # For 32 bit applications
      package = pkgs.unstable.mesa.drivers;
      package32 = pkgs.unstable.pkgsi686Linux.mesa.drivers;

      # extra drivers:
      extraPackages = with pkgs.unstable; [
        #rocmPackages.clr
        #rocmPackages.clr.icd
        #rocmPackages.rocm-runtime

        #amdvlk # amd pro driver -> in env RADV is enabled so this will only be used as fallback I think
      ];
      extraPackages32 = with pkgs.unstable; [
        #driversi686Linux.amdvlk
      ];
    };
  };
  environment = {
    variables = {
      # Configure AMD. Only required if you have AMD iGPU and/or dGPU
      # "AMDVLK" = AMD's Vulkan driver
      # "RADV" = mesa's RADV driver (recommended)
      AMD_VULKAN_ICD = "RADV";
      # Enable raytracing (VKD3D-proton). Recommended with RADV above (not AMDVLK).
      VKD3D_CONFIG = "dxr,dxr11";
      RADV_PERFTEST = "rt";
      ## -> these are from # from https://asus-linux.org/blog/updates-2022-04-16/
      # rocm related
      #ROCR_VISIBLE_DEVICES = extraVar.hardware.rocmgpu;
    };
    systemPackages = with pkgs.unstable; [
      #rocmPackages.rocm-smi
      #rocmPackages.rocminfo
      clinfo
      nvtopPackages.amd
    ];
  };
  # systemd-rules
  systemd.tmpfiles.rules = [
    #"L+    /opt/rocm/hip   -    -    -     -    ${pkgs.unstable.rocmPackages.clr}" # Most software has the HIP libraries hard-coded. You can work around it on NixOS by using this
  ];
}
