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
  systemd.tmpfiles.rules = [
    "d ${containerpath}/querrylog 0750 root root -"
  ];
  containers.${containername} = {
    autoStart = true;
    #extraFlags = ["-U"]; # run as user instead of root
    privateNetwork = true;
    hostBridge = "${br_local_container_name}";
    bindMounts = {
      "/var/lib/querrylog" = {
        hostPath = "${containerpath}/querrylog";
        isReadOnly = false;
      };
    };
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
          allowedTCPPorts = [53 443];
          allowedUDPPorts = [53];
        };
        useHostResolvConf = lib.mkForce false;
      };
      services.adguardhome = {
        enable = true;
        openFirewall = true; # opens port associated with port option (3000 by default)
        mutableSettings = true; # Allow changes made on the AdGuard Home web interface to persist between service restarts.
        settings = {
          # you can add more settings here, they are merged with exisiting settings form webui
          # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
          users = {
            name = "pengolodh";
            password = "Adguard@Home";
          };
          upstream_dns = [
            "tls://fdns1.dismail.de:853"
            "tls://fdns2.dismail.de:853"
          ];
          upstream_mode = "parallel";
          bootstrap_dns = [
            "https://1.1.1.2/dns-query"
            "https://1.0.0.2/dns-query"
          ];
          enable_dnssec = true;
          querrylog.dir_path = "/var/lib/querrylog";
          tls = {
            enabled = true;
            server_name = "adguard.home.pengolodh.be";
            force_https = true;
            port_https = 443;
          };
        };
      };
    };
  };
}
