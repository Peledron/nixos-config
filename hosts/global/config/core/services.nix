# important system services that are configured accross all systems
# --> you can override thse by using services.$servicename.enable = false; in your host system/services.nix
{ config, lib, pkgs, ... }:
{
    # see all options  on https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=services
    # ssh
    services.openssh = lib.mkDefault {  # lib.mkdefault sets this value to a low priority, so that it can be overwritten by other configs
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false; # Change to false to disable passwords entirely
        PermitRootLogin = "no";
      };
      ports = [ 22001 ];
    };
    # ----

    # fail2ban
    services.fail2ban = {
      enable = true;
      maxretry = 5; # max ammount of times an IP can attemt to connect
      # IP ignore list so you dont get blocked accidentally
      ignoreIP = [
        # local IP ranges (loopback + class a,c,b):
        "127.0.0.0/8"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
        # external IP's
        #"8.8.8.8"
      ];
    };
    # ---

    # irqbalance
    services.irqbalance.enable = true; # distributes interrupts across processors and cores
    # ---

    # virtualisation
    virtualisation = lib.mkDefault {
        #  --> libvirt:
        libvirtd = {
            enable = true;
            qemu.ovmf.enable = true;
        };
        #  --> docker:
        docker ={
            enable = true;
        };
    };
    # ----

    # zramswap
    zramSwap.enable = true;
    # ---

    # oomkiller
    systemd.oomd = {
      enable = true;
      # fedora's defaults
      enableRootSlice = true;
      enableSystemSlice = false;
      enableUserServices = true;
    };
}
