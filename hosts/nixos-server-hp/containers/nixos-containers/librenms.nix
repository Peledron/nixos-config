{
  config,
  lib,
  pkgs,
  self,
  inputs,
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
    bindMounts."/persist/ssh/ssh_host_ed25519_key".isReadOnly = true;
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      imports = [inputs.agenix.nixosModules.default];
      # pass the private key to the container for agenix to decrypt the secret

      # import database password with age
      age = {
        identityPaths = ["/persist/ssh/ssh_host_ed25519_key"];
        secrets = {
          librenms_database-password = {
            file = "${self}/.secrets/global/librenms_database-password.age";
          };
        };
      };

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
        hostname = "monitor.home.pengolodh.be";
        # the webportal username and password have to be configued impertivly via the following command
        #lnms user:add --role=admin pengolodh
        database = {
          passwordFile = config.age.secrets.librenms_database-password.path;
        };
      };
      
      #services.oxidized.enable = true;
      system.stateVersion = "23.11";
    };
  };
}
