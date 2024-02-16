{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # ---

  # kernel modules:
  boot = {
    initrd = {
      # modules that are enabled during early load in the initrd (enables the modules in the kernel image that is loaded from the efi partition)
      availableKernelModules = ["amdgpu" "nvme" "aesni_intel" "cryptd" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
      # aesni and cryptd enable the aes accelerated drivers on early boot, so the system boots faster, you can also add  "amdgpu" to make that driver initialize earlier during boot

      kernelModules = ["dm-snapshot"];
      systemd.enable = true; # -> will startup systemd during stage 1 (allows things like plymouth to load early for password entry), boots faster
    };
    kernelModules = ["kvm-amd"];
  };
  # ---

  # hardware settings
  hardware = {
    # vulkan settings
    opengl = {
      # enable vulkan drivers:
      driSupport = true;
      driSupport32Bit = true; # For 32 bit applications

      # extra drivers:
      extraPackages = with pkgs; [
        rocmPackages.clr
        rocmPackages.clr.icd
        rocmPackages.rocm-runtime

        amdvlk # amd pro driver -> in env RADV is enabled so this will only be used as fallback I think
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

    bluetooth = {
      enable = true;
      settings = {
        General = {
          ControllerMode = "bredr";
        };
      };
    };

    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    keyboard.qmk.enable = true; # enable non-root users access to qmk firmware
  };

  # ----
  # systemd-rules
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" # Most software has the HIP libraries hard-coded. You can work around it on NixOS by using this
  ];
  # ----

  # hardware related environment
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
      ROCR_VISIBLE_DEVICES = "GPU-8beaa8932431d436"; # UUID of 7900xt obtained through rocminfo, there is a bug where rocm prefers igpu over dgpu, this is from https://github.com/vosen/ZLUDA
    };
    ## packages related to hardware
    systemPackages = with pkgs; [
      rocmPackages.rocm-smi
      rocmPackages.rocminfo
      clinfo
      nvtop-amd
      qmk
      qmk-udev-rules

      via # keyboard control software
      openrgb-with-all-plugins # rgb control
    ];
  };
  # ----

  # services/program settings
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
}
