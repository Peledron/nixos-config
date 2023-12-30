{config, lib, pkgs, self, sops, ... }:
{
    sops = {

         # import host ssh key as age key
        age = {
            sshKeyPaths = lib.mkDefault ["/etc/ssh/ssh_host_ed25519_key"];
            keyFile = "/var/lib/sops-nix/key"; # this key is then used in the .sops.yaml file
            generateKey = lib.mkDefault false;
        };
    };
}
