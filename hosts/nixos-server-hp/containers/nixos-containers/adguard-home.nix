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
  containername = "adguard-home";
  containerpath = "/persist/var/lib/containerdata/${containername}";
in {
  containers.${containername} = {
    autoStart = true;
    #extraFlags = ["-U"]; # run as user instead of root
    privateNetwork = true;
    hostBridge = "${br_local_container_name}";
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      services.resolved = {
        # Disable local DNS stub listener on 127.0.0.53
        extraConfig = ''
          DNSStubListener=no
        '';
      };
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
          allowedTCPPorts = [53 4000];
          allowedUDPPorts = [53];
        };
        useHostResolvConf = lib.mkForce false;
      };
      services.adguardhome = {
        enable = true;
        openFirewall = true; # opens port associated with port option (3000 by default)
        mutableSettings = true; # Allow changes made on the AdGuard Home web interface to persist between service restarts.
        settings  = {
          # you can add more settings here, they are merged with exisiting settings form webui
          # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
        };
      };
    };
  };
}
