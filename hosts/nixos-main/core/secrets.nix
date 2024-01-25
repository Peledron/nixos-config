{config, lib, pkgs, self, sops, ...}:
{
    sops = {
        # import host ssh key as age key
        age.sshKeyPaths = lib.mkForce [ "/persist/ssh/ssh_host_ed25519_key" ];
    };
}
