{config, lib, pkgs, self, sops, ...}:
{
    sops = {
        age = {
            #sshKeyPaths = [ "/persist/ssh/ssh_host_ed25519_key" ];
            keyFile = "/persist/sops/host.key"; # specify key location, to be added manually from installer
        };
    };
}
