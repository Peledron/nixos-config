{
  config,
  secureBoot,
  ...
}: let
  persistPath = "/nix/persist";
in {
  # note that the filesytem needs to be setup for impernamence, for example tmpfs as /
  # if the system uses a btrfs snapshotting or zfs snapshotting ephemeral system that will need to be specified in the host/impermanence.nix file ( as that is host specific)
  # the reason why you wouldnt want tmpfs for / on all systems is that it requires more memory
  # tell agenix that keys are stored in persist/ssh
  age.identityPaths = [
    "${persistPath}/ssh/ssh_host_ed25519_key"
  ];
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
  networking.wireguard.interfaces.wg0 = {
    generatePrivateKeyFile = true;
    privateKeyFile = "${persistPath}/etc/wireguard/wg0";
  };

  # persist these directories and files
  environment.persistence.${persistPath} = {
    hideMounts = true; # For added "security" and less clutter in the system
    directories = [
      "/var/log" # perserve the system logs
      "/var/lib/systemd/coredump" # perserve the coredump
      "/var/lib/nixos"
      "/var/lib/nixos-containers"
      "/var/lib/machines"

      (lib.mkIf secureBoot "/etc/secureboot")
      (lib.mkIf config.hardware.bluetooth.enable "/var/lib/bluetooth")
      (lib.mkIf config.virtualisation.libvirtd.enable "/var/lib/libvirt" "/etc/libvirt")
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
    ];
    files = [
      #"/etc/machine-id" # -> the nix-mineral module uses a pregenerated machine-id
      "/etc/adjtime" # # systemd ntp time adjust

      # needed when users are mutable
      (
        lib.mkIf users.mutableUsers
        "/etc/passwd"
        "/etc/shadow"
      )
      (
        lib.mkIf config.networking.networkmanager.enable
        "/var/lib/NetworkManager/secret_key"
        "/var/lib/NetworkManager/seen-bssids"
        "/var/lib/NetworkManager/timestamps"
      )

      (lib.mkIf config.services.locate.enable "/var/cache/locatedb") # locatedb cache, the service seems to be unable to replace this file for some reason (ownership maybe?)
    ];
  };

  # disable sudo lecture, it is the warning message that displays the first time you use the sudo command
  security.sudo.extraConfig = lib.mkIf config.security.sudo.enable ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}
