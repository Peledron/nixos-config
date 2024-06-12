{
  config,
  lib,
  pkgs,
  vlans,
  ...
}: let
  br_local_container_name = "br0cont";
  netport = "eth0";
in {
  containers.librenms-oxidized = {
    # librenms is a monitoring solution, oxidized is a network device configuration backup system
    autoStart = true;
    extraFlags = ["-U"]; # run as user instead of root
    privateNetwork = true;
    hostBridge = "${br_local_container_name}";
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      # import database password with age
      age.secrets.librenms_database-password.file = "${self}/.secrets/global/librenms_database-password.age";

      time.timeZone = "Europe/Brussels"; # needs to be set for librenms

      services.resolved.enable = true;
      networking = {
        interfaces = {
          ${netport}.ipv4.addresses = [
            {
              address = "192.168.1.4";
              prefixLength = 24;
            }
          ];
        };
        defaultGateway = {
          address = "192.168.1.3";
          interface = "${netport}";
        };

        useNetworkd = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [80 443];
        };
        useHostResolvConf = lib.mkForce false;
      };
      services.librenms = {
        enable = true;
        database.passwordFile = config.age.secrets.librenms_database-password.path;
      };

      services.oxidized.enable = true;
      system.stateVersion = "23.11";
    };
  };
}