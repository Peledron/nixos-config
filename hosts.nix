{
  lib,
  self,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  overlay-unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      overlay-unstable
    ];
  };

  mkHostConfigModule = import "${self}/hosts/mkHostConfig.nix" {inherit lib self inputs system pkgs;}; # import the module where host and user configs are dynamically imported
  inherit (mkHostConfigModule) mkHostConfig; # define mkHostConfig as mkHostConfigModule.mkHostConfig (a function in the mkHostConfigModule file)
in {
  nixos-main = mkHostConfig {
    hostName = "nixos-main";
    isImpermanent = true;
    desktopEnv = "hyprland";
    moduleConfig.host = {
      hardware = {
        gpu = "amd";
        keychron = true;
        bluetooth = true;
        drawingTablet = true;
      };
      virt.desktop = true; # full enables both libvirt and podman, installs virt-machine-manager
    };
    extraVar = {
      disks = {
        # linux
        linuxRoot = "/dev/disk/by-id/nvme-SAMSUNG_MZVLW512HMJP-000H1_S36ENX0HA25227"; # 512GB root drive
        linuxHome = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB1T0HALR-00000_S3W6NX0N701285"; # 1TB home drive
        linuxDataGames = "/dev/mapper/big--data-data--games"; # 4TB linux-game drive (luks on lvm, once day ill consolidate all these old hard drives into a 2 10tb drives...)
        # windows
        windowsRoot = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S69ENX0TB18294T-part3";
        windowsDataMain = "/dev/disk/by-id/ata-TOSHIBA_DT01ACA300_95QGT6KGS-part2"; # 3tb windows-data drive (ntfs)
        windowsDataMods = "/dev/disk/by-id/ata-ST1000DM003-1ER162_Z4YC0ZWB-part1"; #1TB windows-mod drive (ntfs)
      };
      hardware.rocmgpu = "GPU-8beaa8932431d436";
    };
  };

  nixos-laptop-asus = mkHostConfig {
    hostName = "nixos-laptop-asus";
    isImpermanent = false;
    desktopEnv = "kde";
    extraImports = [inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402];
    extraVar = {
      hardware = {
        gpu = "amd";
      };
    };
  };

  nixos-server-hp = mkHostConfig {
    hostName = "nixos-server-hp";
    isImpermanent = true;

    extraVar = {
      disks = [
        "/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193"
        "/dev/disk/by-id/ata-SanDisk_SD8SBAT128G1002_162092404193-part1"
      ];
      netport = "eno1";
      vlans = [112 113 114];
    };
  };
}
