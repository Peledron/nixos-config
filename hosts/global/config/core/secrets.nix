{config, lib, pkgs, self, sops, ... }:
{
    sops = {

         # import host ssh key as age key
        age = lib.mkDefault {
            #sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
            #keyFile = "/var/lib/sops-nix/host.key"; # this key is then used in the .sops.yaml file
            #generateKey = false;
        };
    };
}
