{
  config,
  lib,
  pkgs,
  system,
  inputs,
  impermanence,
  disko,
  disks,
  ...
}: {
  # clear root subvolume on each boot as per https://grahamc.com/blog/erase-your-darlings/ and https://nixos.wiki/wiki/Btrfs
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt

    # We first mount the btrfs root to /mnt
    # so we can manipulate btrfs subvolumes.
    mount -o subvol=/ ${builtins.elemAt disks 1} /mnt

    # While we're tempted to just delete /root and create
    # a new snapshot from /root-blank, /root is already
    # populated at this point with a number of subvolumes,
    # which makes `btrfs subvolume delete` fail.
    # So, we remove them first.
    #
    # /root contains subvolumes:
    # - /root/var/lib/portables
    # - /root/var/lib/machines
    #
    # I suspect these are related to systemd-nspawn, but
    # since I don't use it I'm not 100% sure.
    # Anyhow, deleting these subvolumes hasn't resulted
    # in any issues so far, except for fairly
    # benign-looking errors from systemd-tmpfiles.
    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
    echo "deleting /$subvolume subvolume..."
    btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvolume..." &&
    btrfs subvolume delete /mnt/root

    echo "restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    # Once we're done rolling back to a blank snapshot,
    # we can unmount /mnt and continue on the boot process.
    umount /mnt
  ''; # from https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

  environment.persistence."/persist" = {
    directories = [
      "/etc/libvirt"
      "/var/lib/docker"
      "/var/lib/containers"
      "/var/lib/containerdata"
      "/var/lib/machines"
      "/var/lib/upower"
    ];
    files = [
      "/etc/machine-id"
      "/etc/adjtime"
    ];
  };

  # disable sudo lecture, it is the warning message that displays the first time you use the sudo command
  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
  services.openssh = {
    enable = true;
    # sets nix to use the host keys in the given directory
    hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
  # tell agenix that keys are stored in persist/ssh
  age.identityPaths = [
    "/persist/ssh/ssh_host_ed25519_key"
  ];
  /*
    networking.wireguard.interfaces.wg0 = {
          generatePrivateKeyFile = true;
          privateKeyFile = "/persist/etc/wireguard/wg0";
  };
  */
  # uncomment if wireguard is used
}
