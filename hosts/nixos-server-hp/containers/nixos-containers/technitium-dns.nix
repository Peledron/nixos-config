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
  containername = "technitium-dns";
in {
  containers.${containername} = {
    autoStart = true;
    #extraFlags = ["-U"]; # run as user instead of root
    privateNetwork = true;
    hostBridge = "${br_local_container_name}";
    bindMounts = {
      "/persist/ssh/ssh_host_ed25519_key".isReadOnly = true;
    };
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      imports = [inputs.agenix.nixosModules.default];
      # pass the private key to the container for agenix to decrypt the secret with bindmounts (see above)

      # import database password with age
      age = {
        identityPaths = ["/persist/ssh/ssh_host_ed25519_key"];
        secrets = {
          technitium-dns-server_admin-password = {
            file = "${self}/.secrets/global/technitium-dns-server_admin-password.age";
            mode = "444";
          };
        };
      };

      services.resolved = {
        # Disable local DNS stub listener on 127.0.0.53
        extraConfig = ''
          DNSStubListener=no
        '';
      };
      networking = {
        interfaces = {
          ${netport} = {
            ipv4.addresses = [
              {
                address = "192.168.1.10";
                prefixLength = 24;
              }
            ];
            ipv6.addresses = [
              {
                address = "fd00:3::10"; # empty will use dhcp and generate a static address from the mac address`
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
          address = "fd00:1::1";
          interface = "${netport}";
        };
        useNetworkd = true;
        useHostResolvConf = lib.mkForce false;
      };
      services.technitium-dns-server = {
        enable = true;
        openFirewall = true; # Whether to open ports in the firewall. Standard ports are 53 (UDP and TCP, for DNS), 5380 and 53443 (TCP, HTTP and HTTPS for web interface). Specify different or additional ports in options firewallUDPPorts and firewallTCPPorts if necessary.
        firewallTCPPorts = [53 80 443];
        firewallUDPPorts = [53];
      };

      systemd.services.technitium-dns-server.environment = lib.mkAfter {
        # see https://github.com/TechnitiumSoftware/DnsServer/blob/master/DockerEnvironmentVariables.md for all options
        # -> note that these are only applied on initial load -> meaning when the service is first created
        DNS_SERVER_DOMAIN = "dns.home.pengolodh.be";
        DNS_SERVER_ADMIN_PASSWORD_FILE = "${config.age.secrets.technitium-dns-server_admin-password.path}";
        DNS_SERVER_WEB_SERVICE_HTTP_PORT = "80";
        DNS_SERVER_WEB_SERVICE_HTTPS_PORT = "443";
        DNS_SERVER_WEB_SERVICE_ENABLE_HTTPS = "true";
        DNS_SERVER_WEB_SERVICE_USE_SELF_SIGNED_CERT = "true";
        DNS_SERVER_FORWARDERS = "zero.dns0.eu"; #"fdns1.dismail.de:853, fdns2.dismail.de:853"; # dismail dns servers # from https://www.dns0.eu/zero, they also have a DoQ implementation but nixos does not have the libmsquic package yet
        DNS_SERVER_FORWARDER_PROTOCOL = "Tls";
        DNS_SERVER_RECURSION = "AllowOnlyForPrivateNetworks"; #  #Recursion options: Allow, Deny, AllowOnlyForPrivateNetworks, UseSpecifiedNetworks.
        DNS_SERVER_BLOCK_LIST_URLS = "https://big.oisd.nl, https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/multi.txt, https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/tif-onlydomains.txt, https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/doh.txt, https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/hoster-onlydomains.txt, https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/gambling-onlydomains.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt";
      };
      #environment.systemPackages = with pkgs; [libmsquic];
    };
  };
}
