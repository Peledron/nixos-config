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
  secret-location = "${self}/.secrets/global/containers/nextcloud";
in {
  containers.nextcloud = {
    # librenms is a monitoring solution, oxidized is a network device configuration backup system
    autoStart = true;
    #extraFlags = ["-U"]; # run as user instead of root
    privateNetwork = true;
    hostBridge = "${br_local_container_name}";
    bindMounts."/persist/ssh/ssh_host_ed25519_key".isReadOnly = true; # pass the private key to the container for agenix to decrypt the secret
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      imports = [inputs.agenix.nixosModules.default];

      # import database password with age
      age = {
        identityPaths = ["/persist/ssh/ssh_host_ed25519_key"];
        secrets = {
          nextcloud-DB-password = {
            file = "${secret-location}/nextcloud-DB-password.age";
            mode = "440";
            owner = "nextcloud";
            group = "nextcloud";
          };
          nextcloud-ADMIN-password = {
            file = "${secret-location}/nextcloud-ADMIN-password.age";
            mode = "440";
            owner = "nextcloud";
            group = "nextcloud";
          };
          storage-share_sync-pengolodh_credentials = {
            file = "${secret-location}/storage-share_sync-pengolodh_credentials.age";
            name = "storagebox-sync.conf";
            mode = "440";
          };
        };
      };

      time.timeZone = "Europe/Brussels";

      services.resolved.enable = true;
      networking = {
        interfaces = {
          ${netport} = {
            ipv4.addresses = [
              {
                address = "192.168.1.25";
                prefixLength = 24;
              }
            ];
            ipv6.addresses = [
              {
                address = "fd00:3::25"; # empty will use dhcp and generate a static address from the mac address`
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
      services.nextcloud = {
        enable = true;
        hostName = "nextcloud.home.pengolodh.be";
        https = true;
        configureRedis = true;
        maxUploadSize = "1G";
        config = {
          adminuser = "admin";
          adminpassFile = config.age.secrets.nextcloud-ADMIN-password.path;
        };
        database.createLocally = true;
        extraOptions.enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
        ];
      };
      environment.systemPackages = with pkgs; [fuse-common rclone];
      environment.etc."rclone-mnt.conf".source = config.age.secrets.storage-share_sync-pengolodh_credentials.path;
      # --> dont forget that you need to obscure the password with 'echo "secretpassword" | rclone obscure -'
      fileSystems."/mnt" = {
        device = "storagebox-sync:/";
        fsType = "rclone";
        options = [
          "nodev"
          "nofail"
          "allow_other"
          "args2env"
          "vfs_cache_mode=full"
          "vfs_cache_max_age=1d"
          "vfs_cache_max_size=50G"
          "config=${config.age.secrets.storage-share_sync-pengolodh_credentials.path}"
        ];
      };

      services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
        forceSSL = true;
        enableACME = true;
      };
      #services.cachefilesd.enable = true;
      security.acme = {
        acceptTerms = true;
        certs = {
          ${config.services.nextcloud.hostName}.email = "pengolodh.noldor@gmail.com";
        };
      };
      system.stateVersion = "24.05";
    };
  };
}
