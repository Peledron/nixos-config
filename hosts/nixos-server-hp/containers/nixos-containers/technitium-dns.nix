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
  containerpath = "/persist/var/lib/containerdata/${containername}";
in {
  systemd.tmpfiles.rules = [
    "d ${containerpath} 0750 root root -"
  ];
  containers.${containername} = {
    autoStart = true;
    #extraFlags = ["-U"]; # run as user instead of root
    privateNetwork = true;
    hostBridge = "${br_local_container_name}";
    bindMounts = {
      "/persist/ssh/ssh_host_ed25519_key".isReadOnly = true;
      "/var/lib/technitium-dns-server" = {
        hostPath = "${containerpath}";
        isReadOnly = false;
      };
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
          ${netport}.ipv4.addresses = [
            {
              address = "192.168.1.14";
              prefixLength = 24;
            }
          ];
        };
        defaultGateway = {
          address = "192.168.1.3";
          interface = "${netport}";
        };

        useNetworkd = true;
        useHostResolvConf = lib.mkForce false;
      };
      services.technitium-dns-server = {
        enable = true;
        openFirewall = true; # Whether to open ports in the firewall. Standard ports are 53 (UDP and TCP, for DNS), 5380 and 53443 (TCP, HTTP and HTTPS for web interface). Specify different or additional ports in options firewallUDPPorts and firewallTCPPorts if necessary.
      };
      environment.variables = {
        DNS_SERVER_DOMAIN = "dns.home.pengolodh.be";
        DNS_SERVER_ADMIN_PASSWORD_FILE = "${config.age.secrets.technitium-dns-server_admin-password.path}";
        #DNS_SERVER_WEB_SERVICE_HTTP_PORT = 80;
        #DNS_SERVER_WEB_SERVICE_HTTPS_PORT = 443;
        DNS_SERVER_WEB_SERVICE_ENABLE_HTTPS = "true";
        DNS_SERVER_WEB_SERVICE_USE_SELF_SIGNED_CERT = "true";
        DNS_SERVER_RECURSION = "AllowOnlyForPrivateNetworks";
        DNS_SERVER_BLOCK_LIST_URLS = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_34.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_47.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_55.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_52.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt, https://adguardteam.github.io/HostlistsRegistry/assets/filter_23.txt";
      };
    };
  };
}
