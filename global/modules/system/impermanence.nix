{
  config,
  lib,
  extraVar,
  secureBoot,
  ...
}: let
  persistPath = "/nix/persist";
in {
  # note that the filesytem needs to be setup for impernamence, for example tmpfs as /
  # if the system uses a btrfs snapshotting or zfs snapshotting ephemeral system that will need to be specified in the host/impermanence.nix file ( as that is host specific)
  # the reason why you wouldnt want tmpfs for / on all systems is that it requires more memory
  # we use disko to define the system disks we want nixos to be installed on, this way they will be partitioned automatically when we use a tool like nixos-anywhere
  disko.devices = lib.mkDefault {
    disk.nixosRoot = {
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
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=8G"
        "defaults"
        "mode=755"
      ];
    }; # root will be on a tmpfs, it can grow to a maximum of 8G, this should be plenty
  };
  fileSystems = lib.mkDefault {
    "/".neededForBoot = true;
    "/nix".neededForBoot = true;
  };

  # tell agenix that keys are stored in persist/ssh
  age.identityPaths = [
    "${persistPath}/ssh/ssh_host_ed25519_key"
  ];
  # openssh can create its own keys if they do not exist yet
  services.openssh = {
    enable = true;
    # sets nix to use/generate the host keys in the given directory
    hostKeys = [
      {
        path = "${persistPath}/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "${persistPath}/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
  # same with wireguard
  networking.wireguard.interfaces.wg0 = {
    generatePrivateKeyFile = true;
    privateKeyFile = "${persistPath}/etc/wireguard/wg0";
  };

  # persist these directories and files
  environment.persistence.${persistPath} = {
    hideMounts = true; # For added "security" and less clutter in the system
    directories =
      [
        "/var/log" # perserve the system logs
        "/var/lib/systemd/coredump" # perserve the coredump
        "/var/lib/nixos"
        "/var/lib/nixos-containers"
        "/var/lib/machines"

        (lib.mkIf secureBoot "/etc/secureboot")
        (lib.mkIf config.hardware.bluetooth.enable "/var/lib/bluetooth")
        (lib.mkIf config.virtualisation.docker.enable "/var/lib/docker")
        (lib.mkIf config.networking.networkmanager.enable "/etc/NetworkManager/system-connections")

        (lib.mkIf config.services.upower.enable "/var/lib/upower")
        (
          lib.mkIf config.services.colord.enable
          {
            directory = "/var/lib/colord";
            user = "colord";
            group = "colord";
            mode = "u=rwx,g=rx,o=";
          } # colord map needs to belong to the colord user
        )
      ]
      ++ lib.optionals config.virtualisation.libvirtd.enable ["/var/lib/libvirt" "/etc/libvirt"];
    files =
      [
        #"/etc/machine-id" # -> the nix-mineral module uses a pregenerated machine-id
        "/etc/adjtime" # # systemd ntp time adjust

        (lib.mkIf config.services.locate.enable "/var/cache/locatedb") # locatedb cache, the service seems to be unable to replace this file for some reason (ownership maybe?)
      ]
      ++ lib.optionals
      config.networking.networkmanager.enable
      [
        "/var/lib/NetworkManager/secret_key"
        "/var/lib/NetworkManager/seen-bssids"
        "/var/lib/NetworkManager/timestamps"
      ]
      ++ lib.optionals
      config.users.mutableUsers
      [
        "/etc/passwd"
        "/etc/shadow"
      ];
  };

  # disable sudo lecture, it is the warning message that displays the first time you use the sudo command, with ephemeral setups it does that each time
  security.sudo.extraConfig = lib.mkIf config.security.sudo.enable ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}
