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
  containers.blocky = {
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
      services.resolved.enable = true;
      networking = {
        interfaces = {
          ${netport}.ipv4.addresses = [
            {
              address = "192.168.1.10";
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
          allowedTCPPorts = [53];
          allowedUDPPorts = [53];
        };
        useHostResolvConf = lib.mkForce false;
      };

    };
  };
}
/*
# useful for self hosted services
customDNS:
  customTTL: 1h
  mapping:
    someservice.bayas.dev: 10.1.0.4

# useful for local network DNS resolution
conditional:
  mapping:
    lan: 10.1.0.1
    # for reverse DNS lookups of local devices
    0.1.10.in-addr.arpa: 10.1.0.1
    # for all unqualified hostnames
    .: 10.1.0.1
*/

