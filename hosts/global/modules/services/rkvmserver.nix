{
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    rkvm = {
      enable = true;
      server = {
        enable = true;
        settings = {
          switch-keys = [
            "left-alt"
            "right-alt"
          ];
          key = "/persist/etc/rkvm/key.pem";
          certificate = "/persist/etc/rkvm/certificate.pem";
          # -> need to manually generate  these files via rkvm-certificate-gen -i <ip-address-list> certificate.pem key.pem
          password = "%6nrY8S4@"; # shouldn't matter much, the attacker would need the certificate and access to my local network
          listen = "0.0.0.0:52581";
        };
      };
    };
  };
}
