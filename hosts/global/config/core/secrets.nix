{config, lib, pkgs, self, sops, ... }:
{
    sops = {
        defaultSopsFile = ./secrets/secrets.yaml ;
         # import host ssh key as age key
        age = {
            sshKeyPaths = lib.mkDefault ["/etc/ssh/ssh_host_ed25519_key"];
            keyFile = "/var/lib/sops-nix/key.txt"; # this key is then defined in the
            generateKey = true;
        };
    };
}
