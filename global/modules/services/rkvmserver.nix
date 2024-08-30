{
  config,
  pkgs,
  self,
  ...
}: {
  age.secrets = {
    kvm-server_key = {
      name = "key.pem"; # name of file after encryption
      file = "${self}/.secrets/global/rkvm-server_key.age"; # location of encrypted file
      mode = "400";
    };
    kvm-server_cert = {
      name = "certificate.pem";
      file = "${self}/.secrets/global/rkvm-server_cert.age";
      mode = "444";
    };
  };
  services = {
    rkvm = {
      enable = true;
      package = pkgs.unstable.rkvm;
      server = {
        enable = true;
        settings = {
          switch-keys = [
            "left-alt"
            "right-alt"
          ];
          key = config.age.secrets.kvm-server_key.path;
          certificate = config.age.secrets.kvm-server_cert.path;
          # -> need to manually generate  these files via rkvm-certificate-gen -i <ip-address-list> certificate.pem key.pem
          password = "%6nrY8S4@"; # shouldn't matter much, the attacker would need the certificate and access to my local network
          listen = "0.0.0.0:52581";
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [52581];
}
