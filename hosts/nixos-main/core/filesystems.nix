# drive config
{
  config,
  lib,
  pkgs,
  disko,
  extraVar,
  isImpermanent,
  mainUser,
  ...
}: {
  # we use disko to define the system disks we want nixos to be installed on, this way they will be partitioned automatically when we use a tool like nixos-anywhere
  disko.devices = {
    disk.nixosRoot = lib.mkIf isImpermanent {
      device = extraVar.disks.linuxRoot;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "NIXOS_EFI";
            size = "512M";
            type = "EF00"; # efi partition type
            content = {
              # here we will tell it the filesystem type and mountpoint
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["defaults"];
            };
          };
          cr_nixosRoot = {
            size = "100%";
            content = {
              type = "luks";
              name = "cr_nixosRoot";
              settings.allowDiscards = true;
              passwordFile = "/tmp/nixosRoot.passwd"; # if you want this to be a password use echo -n "password" > /tmp/nixos-main.key , the -n is very important as it removes the trailing newline, the /tmp is only for the installer, this file is only used when the disk is partitioned by disko
              # no keyfile will be specified as there will only be a password for this disk
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix";
              };
            };
          };
        };
      };
    };
    nodev."/" = lib.mkIf isImpermanent {
      fsType = "tmpfs";
      mountOptions = [
        "size=8G"
        "defaults"
        "mode=755"
      ];
    }; # root will be on a tmpfs, meaning that it is impermament

    # -- make if not impermanent --
    disk.nixosRoot = lib.mkIf (isImpermanent == false) {
      device = extraVar.disks.linuxRoot;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "NIXOS_EFI";
            size = "512M";
            type = "EF00"; # efi partition type
            content = {
              # here we will tell it the filesystem type and mountpoint
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["defaults"];
            };
          };
          cr_nixosRoot = {
            size = "100%";
            content = {
              type = "luks";
              name = "cr_nixroot";
              settings.allowDiscards = true;
              passwordFile = "/tmp/nixos-root.passwd"; # if you want this to be a password use echo -n "password" > /tmp/nixos-main.key , the -n is very important as it removes the trailing newline, the /tmp is only for the installer, this file is only used when the disk is partitioned by disko
              # no keyfile will be specified as there will only be a password for this disk
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
    # --
  };
  # ---
  # using crypttab will allow systemd to auto-mount the devices on stage2 of the boot process (after initrd and nixos mounts are done), this should work...
  environment.etc.crypttab = {
    enable = true;
    text = ''
      cr_home ${extraVar.disks.linuxHome}-part1 /nix/keys/data-home.key luks,discard
      cr_games ${extraVar.disks.linuxDataGames} /nix/keys/data-games.key luks
    '';
  };
  swapDevices = [
    {
      device = "/nix/swapfile";
      size = 32768; # swapfile will be created automatically witth this size (in MB)
      priority = 0; #  Priority is a value between 0 and 32767. Higher numbers indicate higher priority. null lets the kernel choose a priority, which will show up as a negative value.
    }
  ];
  # define existing disks here, as well as other options that do not need/are able to be covered by disko
  fileSystems = {
    "/".neededForBoot = true;
    "/nix".neededForBoot = true;
    "/home" = {
      device = "/dev/mapper/cr_home";
      fstype = "btrfs";
      options = ["compress=zstd" "noatime"];
    };
    "/home/pengolodh/Games" = {
      device = "/dev/mapper/cr_games"; # see below for the crypttab configuration
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/Windows/windows-root" = {
      device = extraVar.disks.windowsRoot;
      fsType = "ntfs3";
      options = ["defaults" "noatime" "nofail" "sys_immutable" "windows_names" "uid=1000" "gid=1000" "user" "umask=027" "discard"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/Windows/windows-data-main" = {
      device = extraVar.disks.windowsDataMain;
      fsType = "ntfs3";
      options = ["defaults" "noatime" "nofail" "windows_names" "uid=1000" "gid=1000" "user" "umask=027"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/Windows/windows-data-mods" = {
      device = extraVar.disks.windowsDataMods;
      fsType = "ntfs3";
      options = ["defaults" "noatime" "nofail" "windows_names" "uid=1000" "gid=1000" "user" "umask=027"];
      depends = ["/home"];
    };
  };
  # ---

  # we are using btrfs so we can enable the scrub service here, as it is filesystem dependant
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/home"]; # does not need to be done on the nested sub-volumes "/nix" "/persist"
  };
  services.snapper = {
    snapshotInterval = "hourly";
    persistentTimer = true; # continue timer through restarts
    configs.home = {
      SUBVOLUME = "/home/${mainUser}";
      ALLOW_USERS = ["${mainUser}"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
    }; # note that you should exclude subpaths paths like for example "~/VM" by making them as a subvolume, the snapshot will not include them
  };
}
