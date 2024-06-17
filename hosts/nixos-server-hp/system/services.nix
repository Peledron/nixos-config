# important system services
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [(self + "/global/modules/virt/podman.nix")];

  # disable autosuspend on lid close so we can use the laptop as a server
  services.logind.lidSwitch = "ignore";
  services.auto-cpufreq.enable = true;
  #services.logrotate.checkConfig = false; # workaround for a bug

  systemd.services.sshd.after = ["network.target" "systemd-networkd.service"]; # sets sshd to boot after network, otherwise it fails at startup due to listenAddress not existing yet
  services.blocky = {
    enable = true;
    settings = {
      # adapted from https://bayas.dev/posts/blocky-adblock-docker-setup
      upstreams = {
        groups = {
          default = [
            # unecrypted
            "1.1.1.2"
            "1.0.0.2"
            # encrypted DoH
            "https://dns.nextdns.io"
            "https://1.1.1.2/dns-query"
          ];
        };
        # blocky will pick the 2 fastest upstreams but you can also use the `strict` strategy
        strategy = "parallel_best";
        timeout = "2s";
      };
      # check if upstreams are working
      startVerifyUpstream = true;
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
}
