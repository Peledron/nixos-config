# drive config
{
  lib,
  extraVar,
  mainUser,
  ...
}: {
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
  # define existing disks here
  fileSystems = {
    "/home" = lib.mkForce {
      device = "/dev/mapper/cr_home";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime" "nodev" "nosuid"]; # enable compression and some security options
    };
    "/home/pengolodh/Games" = {
      device = "/dev/mapper/cr_games"; # see below for the crypttab configuration
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail" "nodev" "nosuid"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/Windows/windows-root" = {
      device = extraVar.disks.windowsRoot;
      fsType = "ntfs3";
      options = ["defaults" "noatime" "nofail" "sys_immutable" "windows_names" "uid=1000" "gid=100" "user" "umask=077" "discard"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/Windows/windows-data-main" = {
      device = extraVar.disks.windowsDataMain;
      fsType = "ntfs";
      options = ["defaults" "noatime" "nofail" "windows_names" "uid=1000" "gid=100" "user" "umask=077"];
      depends = ["/home"];
    };
    "/home/pengolodh/Data/Windows/windows-data-mods" = {
      device = extraVar.disks.windowsDataMods;
      fsType = "ntfs3";
      options = ["defaults" "noatime" "nofail" "windows_names" "uid=1000" "gid=100" "user" "umask=077"];
      depends = ["/home"];
    };
  };
  # ---
  boot.tmp.useTmpfs = true; # mount /tmp as a tmpfs filesystem, it will be cleared at each boot
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
