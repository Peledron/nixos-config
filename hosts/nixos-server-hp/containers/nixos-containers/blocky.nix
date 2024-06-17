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
          allowedTCPPorts = [53];
          allowedUDPPorts = [53];
        };
        useHostResolvConf = lib.mkForce false;
      };
      services.blocky = {
        enable = true;
        settings = {
          # adapted from https://bayas.dev/posts/blocky-adblock-docker-setup
          upstreams = {
            groups = {
              default = [
                "tcp-tls:fdns1.dismail.de:853"
                "tcp-tls:fdns2.dismail.de:853"
              ];
            };
            # blocky will pick the 2 fastest upstreams but you can also use the `strict` strategy
            strategy = "parallel_best";
            timeout = "2s";
          };
          # check if upstreams are working
          #init.strategy = true;
          # we will not be using ipv6 for now
          connectIPVersion = "v4";

          blocking = {
            # I prefer the HaGeZi Light blocklist for set and forget setup, you can use any other blacklist nor whitelist you want
            # Blocky supports hosts, domains and regex syntax
            blackLists = {
              ads = [
                "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/multi.txt"
              ];
            };

            clientGroupsBlock = {
              default = [
                "ads"
              ];
            };
            blockType = "zeroIp";
            blockTTL = "1m";
            loading = {
              refreshPeriod = "6h";
              downloads = {
                timeout = "60s";
                attempts = 5;

                cooldown = "10s";
              };
              concurrency = 16;
              # start answering queries immediately after start
              strategy = "fast";
              maxErrorsPerSource = 5;
            };
          };
          caching = {
            # enable prefetching improves performance for often used queries
            prefetching = true;
            # if a domain is queried more than prefetchThreshold times, it will be prefetched for prefetchExpires time
            prefetchExpires = "24h";
            prefetchThreshold = 2;
          };
          # use encrypted DNS for resolving upstreams
          # same syntax as normal upstreams
          bootstrapDns = [
            "https://1.1.1.2/dns-query"
          ];
        };
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

