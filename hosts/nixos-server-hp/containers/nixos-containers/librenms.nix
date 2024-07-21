{
  config,
  lib,
  pkgs,
  self,
  inputs,
  ...
}: let
  br_local_container_name = "br0cont";
  netport = "eth0";
in {
  containers.librenms = {
    # librenms is a monitoring solution, oxidized is a network device configuration backup system
    autoStart = true;
    #extraFlags = ["-U"]; # run as user instead of root
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
          librenms_DB_password = {
            file = "${self}/.secrets/global/containers/librenms/librenms_DB_password.age";
            mode = "440";
            owner = "librenms";
            group = "librenms";
          };
          librenms_LIBRENMS_env = {
            file = "${self}/.secrets/global/containers/librenms/librenms_LIBRENMS_env.age";
            mode = "440";
            owner = "librenms";
            group = "librenms";
          };
        };
      };

      time.timeZone = "Europe/Brussels"; # needs to be set for librenms

      services.resolved.enable = true;
      networking = {
        interfaces = {
          ${netport} = {
            ipv4.addresses = [
              {
                address = "192.168.1.3";
                prefixLength = 24;
              }
            ];
            ipv6.addresses = [
              {
                address = "fd00:3::3"; # empty will use dhcp and generate a static address from the mac address`
                prefixLength = 64;
              }
              {
                address = ""; # empty will use dhcp
                prefixLength = 64;
              }
            ];
          };
        };
        defaultGateway = {
          address = "192.168.1.2";
          interface = "${netport}";
        };
        defaultGateway6 = {
          address = "fd00:3::1";
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
        hostname = "netmon.home.pengolodh.be";
        user = "librenms";
        group = "librenms";
        enableOneMinutePolling = true;
        database = {
          createLocally = true; # automatically create the database (creates a mySQL server wth the librenms user)
          passwordFile = config.age.secrets.librenms_DB_password.path;
        };
        nginx = {
          #addSSL = true;
          forceSSL = true;
          enableACME = true; #requests a letsencrypt certificate for the webserver
        };
        settings = {
          webui.style.name = "dark";
        };
        #environmentFile = config.age.secrets.librenms_LIBRENMS_env.path;
      };
      security.acme = {
        # needed for enableACME option
        acceptTerms = true;
        defaults.email = "pengolodh.noldor@gmail.com";
      };
      #services.redis.servers.librenms-redis.enable = true; # -> memcached is enabled by default
      services.syslog-ng.enable = true; #
      #services.oxidized.enable = true;
      system.stateVersion = "24.05";
    };
  };
}
