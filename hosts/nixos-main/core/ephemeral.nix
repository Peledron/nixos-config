{...}: let
  persistPath = "/nix/persist";
in {
  # root partition is hosted on tmpfs, it is cleared by default on reboots (since it resides in memory)

  environment.persistence.${persistPath} = {
    hideMounts = true; # For added "security" and less clutter in the system
    directories = [
      "/etc/libvirt" # persist the libvirt configuration directory
      "/etc/NetworkManager/system-connections"
      "/var/log" # perserve the system logs
      "/var/lib/nixos"
      "/var/lib/systemd/coredump" # perserve the coredump on reboots
      "/var/lib/docker"
      "/var/lib/containers"
      "/var/lib/upower"
      "/var/lib/bluetooth"
      "/var/lib/libvirt"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      } # colord map needs to belong to the colord user
    ];
    files = [
      # systemd unique machine id and ntp time adjust
      "/etc/machine-id"
      "/etc/adjtime"
      # network manager is enabled so we need the following files t`o be persistent for wifi
      # locatedb cache
      "/var/cache/locatedb"
      #
      {
        file = "/var/keys/secret_file";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
    ];
  };

  # disable sudo lecture, it is the warning message that displays the first time you use the sudo command
  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

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
  # tell agenix that keys are stored in persist/ssh
  age.identityPaths = [
    "${persistPath}/ssh/ssh_host_ed25519_key"
  ];

  /*
    networking.wireguard.interfaces.wg0 = {
          generatePrivateKeyFile = true;
          privateKeyFile = "/persist/etc/wireguard/wg0";
  };
  */
  # uncomment if wireguard is used
}
