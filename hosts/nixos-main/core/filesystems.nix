# drive config
{
  config,
  lib,
  pkgs,
  disko,
  ...
}: {
  # we use disko to define the system disks we want nixos to be installed on, this way they will be partitioned automatically when we use a tool like nixos-anywhere
  disko.devices = {
    disk.nixos-root = {
      device = builtins.elemAt config.disks 0;
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
          cr_swap = {
            size = "16G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
          cr_nixos-main = {
            size = "100%";
            content = {
              type = "luks";
              name = "cr_nixos-main";
              settings.allowDiscards = true;
              passwordFile = "/tmp/nixos-main.passwd"; # if you want this to be a password use echo -n "password" > /tmp/nixos-main.key , the -n is very important as it removes the trailing newline, the /tmp is only for the installer, this file is only used when the disk is partitioned by disko
              # no keyfile will be specified as there will only be a password for this disk
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # force create the partition
                subvolumes = {
                  "SYSTEM" = { };
                  "SYSTEM/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "SYSTEM/persist" = {
                    mountpoint = "/persist";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
    disk.home = {
      device = builtins.elemAt config.disks 1;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          cr_home = {
            size = "100%";
            content = {
              type = "luks";
              name = "cr_home";
              passwordFile = "/tmp/data-home.passwd";
              additionalKeyFiles = ["/tmp/data-home.key"];
              settings = {
                allowDiscards = true;
                #keyFile = "/nix/keys/data-home.key"; # path to the disk encryption key (for boot)
              };
              initrdUnlock = false; # do not add this drive to the initrd devices mounted during boot, we will do this in stage 2 using systemd crypttab file instead (see below)
              content = {
                type = "btrfs";
                #extraArgs = ["-f"]; # force Override existing partition
                subvolumes = {
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/home/pengolodh" = {}; # /home is mounted, so home/user does not need to be (it acts as a folder, I assume that the compression will still be applied to the sub-subvolume)
                };
              };
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=8G"
        "defaults"
        "mode=755"
      ];
    }; # root will be on a tmpfs, meaning that it is impermament
  };
  # ---

  # define existing disks here, as well as other options that do not need/are able to be covered by disko
  fileSystems = {
    "/".neededForBoot = true;
    "/nix".neededForBoot = true;
    "/persist".neededForBoot = true;
    "/home/pengolodh/Games" = {
      device = "/dev/mapper/cr_games"; # see below for the crypttab configuration
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail"];
      depends = ["home"];
    };
    "/home/pengolodh/Data/Windows/windows-root" = {
      device = builtins.elemAt config.disks 2;
      fsType = "ntfs";
      options = ["defaults" "noatime" "nofail" "uid=1000" "gid=1000" "rw" "user" "exec" "umask=000"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/Windows/windows-data-main" = {
      device = builtins.elemAt config.disks 4;
      fsType = "ntfs";
      options = ["defaults" "noatime" "nofail" "uid=1000" "gid=1000" "rw" "user" "exec" "umask=000"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/Windows/windows-data-mods" = {
      device = builtins.elemAt config.disks 5;
      fsType = "ntfs";
      options = ["defaults" "noatime" "nofail" "uid=1000" "gid=1000" "rw" "user" "exec" "umask=000"];
      depends = ["/home"];
    };
  };
  # ---

  # using crypttab will allow systemd to auto-mount the devices on stage2 of the boot process (after initrd and nixos mounts are done), this should work...
  environment.etc.crypttab = {
    enable = true;
    text = ''
      cr_home ${builtins.elemAt config.disks 1}-part1 /nix/keys/data-home.key luks,discard
      cr_games ${builtins.elemAt config.disks 3} /nix/keys/data-games.key luks
    '';
  };
  # ---

  # we are using btrfs so we can enable the scrub service here, as it is filesystem dependant
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/nix" "/persist" "/home"]; # does not need to be done on the nested sub-volumes
  };
}
