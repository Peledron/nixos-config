# drive config
{
  config,
  lib,
  pkgs,
  disko,
  disks,
  ...
}: {
  # using zfs, following from https://www.reddit.com/r/NixOS/comments/ruyunj/comment/hr4lijv/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  disko.devices = {
    disk.nixos-root = {
      device = builtins.elemAt disks 0;
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
          cr_nixos-main = {
            size = "60G";
            content = {
              type = "luks";
              name = "cr_nixos-main";
              settings.allowDiscards = true;
              passwordFile = "/tmp/nixos-main.passwd"; # if you want this to be a password use echo -n "password" > /tmp/nixos-main.key , the -n is very important as it removes the trailing newline
              # no keyfile will be specified as there will only be a password for this disk
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/nix";
              };
            };
          };
          cr_swap = {
            size = "16G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
          cr_nixos-persist = {
            size = "100%";
            content = {
              type = "luks";
              name = "cr_nixos-persist";
              passwordFile = "/tmp/nixos-main.passwd"; # the password will be the same as /nix, this will only prompt for 1 password and reuse the given one at boot
              additionalKeyFiles = ["/tmp/nixos-persist.key"];
              settings = {
                allowDiscards = true;
                #keyFile = "/nix/keys/nixos-persist.key"; # generated using openssl-genrsa -out
              };
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/persist";
              };
            };
          };
        };
      };
    };
    disk.home = {
      device = builtins.elemAt disks 1;
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
                extraArgs = ["-f"]; # force create the partition
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
    "/home/pengolodh/Data/windows/windows-root" = {
      device = builtins.elemAt disks 2;
      fsType = "ntfs";
      options = ["defaults" "noatime" "nofail"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/windows/windows-data-main" = {
      device = builtins.elemAt disks 4;
      fsType = "ntfs";
      options = ["defaults" "noatime" "nofail"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/windows/windows-data-mods" = {
      device = builtins.elemAt disks 5;
      fsType = "ntfs";
      options = ["defaults" "noatime" "nofail"];
      depends = ["/home"];
    };
  };

  # using crypttab will allow systemd to auto-mount the devices on stage2 of the boot process (after initrd and nixos mounts are done), this should work...
  environment.etc.crypttab = {
    enable = true;
    text = ''
      cr_home ${builtins.elemAt disks 1}-part1 /nix/keys/data-home.key luks,discard
      cr_games ${builtins.elemAt disks 3} /nix/keys/data-games.key luks
    '';
  };
  # ---

  # we are using btrfs so we can enable the scrub service here, as it is filesystem dependant
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/home"]; # does not need to be done on the nested sub-volumes
  };
}
