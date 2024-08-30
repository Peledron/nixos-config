# important system services that are configured accross all systems
# --> you can override thse by using services.$servicename.enable = false; in your host system/services.nix
{
  config,
  lib,
  mainUser,
  ...
}: {
  # see all options  on https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=services
  # ssh
  services.openssh = lib.mkDefault {
    # lib.mkdefault sets this value to a low priority, so that it can be overwritten by other configs
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false; # Change to false to disable passwords entirely
      PermitRootLogin = "no";
      X11Forwarding = false;
      AllowUsers = [mainUser];
    };
    ports = [22001];
  };
  networking.firewall.allowedTCPPorts = config.services.openssh.ports;
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
    bantime = "24h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64"; # each incriment will chrange the multiplier to the next entry in this list, so 1*2 1*4, etc
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
  };
  # ---

  # irqbalance
  services.irqbalance.enable = true; # distributes interrupts across processors and cores
  # ---

  # zramswap
  zramSwap.enable = true; # will create a compressed swapdevice with half the system ram by default
  # ---

  # oomkiller
  systemd = {
    enableUnifiedCgroupHierarchy = true;
    oomd = {
      enable = true;
      # fedora's defaults
      enableRootSlice = true;
      enableSystemSlice = false;
      enableUserSlices = true;
    };
  };
  services.locate = {
    enable = true;
    #package = pkgs.plocate;
    interval = "daily";
    #localuser = null; # silences a warning that updatedb cannot use any other user than root, only needed for plocate
  };
}
