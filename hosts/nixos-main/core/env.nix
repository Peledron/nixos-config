{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.variables = {
    # from https://asus-linux.org/blog/updates-2022-04-16/

    # Configure AMD. Only required if you have AMD iGPU and/or dGPU
    # "AMDVLK" = AMD's Vulkan driver
    # "RADV" = mesa's RADV driver (recommended)
    AMD_VULKAN_ICD = "RADV";
    # Enable raytracing (VKD3D-proton). Recommended with RADV above (not AMDVLK).
    VKD3D_CONFIG = "dxr,dxr11";
    RADV_PERFTEST = "rt";
  };
}
