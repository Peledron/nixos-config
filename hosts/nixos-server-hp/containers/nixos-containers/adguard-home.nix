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
    "d ${containerpath}/logs 0750 root root -"
  ];
  containers.${containername} = {
    autoStart = true;
    #extraFlags = ["-U"]; # run as user instead of root
    privateNetwork = true;
    hostBridge = "${br_local_container_name}";
    bindMounts = {
      "/var/lib/adguard-logs" = {
        hostPath = "${containerpath}/logs";
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
          # you can add more settings here, they are merged with exisiting settings form webui if mutableSettings is true, these options are merged into the configuration file on start, taking precedence over configuration changes made on the web interface.
          # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
          users = [
            {
              name = "pengolodh";
              password = "$2y$10$6T6TazxuJiOovjPTGJKIM.OHoUk411kjYJKeaR0PrJAnK1ug/DxD2"; # hash generated via htpasswd -B -C 10 -n -b %user% %password%
            }
          ];

          dns = {
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
            cache_size = 268435456; # 256MiB
            cache_ttl_min = 15; # time in seconds, 15s
            cache_ttl_max = 28800; # time in seconds, 8h

          };
          filters = [
            {
              enabled = true;
              urls = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"; # adguard standard list
              name = "AdGuard DNS filter";
              id = 1;
            }
            {
              enabled = true;
              urls = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/multi.txt"; # adguard standard list
              name = "hagezi-normal";
              id = 1719424238;
            }
          ];

          tls = {
            enabled = true;
            server_name = "adguard.home.pengolodh.be";
            force_https = true;
            port_https = 443;
            port_dns_over_tls = 0;
            port_dns_over_quick = 0;
          };
          filtering = {
            rewrites = [
              {
                domain = "adguard.home.penglodh.be";
                answer = "192.168.1.10";
              }
            ];
            blocking_mode = "default";
            protection_enabled = true;
            parental_enabled = false;
            safebrowsing_enabled = false;
          };
          querrylog.dir_path = "/var/lib/adguard-logs";
          log.file = "/var/lib/adguard-logs/adguardlog.log";
        };
      };
    };
  };
}
