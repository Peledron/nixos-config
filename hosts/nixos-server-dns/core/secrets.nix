{config, lib, pkgs, self, sops, ...}:
{
    sops = {
        # import host ssh key as age key
        age = {
            keyFile = "/var/lib/sops-nix/host.key";
        };
    };
}
