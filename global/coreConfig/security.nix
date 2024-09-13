{
  lib,
  pkgs,
  config,
  mainUser,
  ...
}: {
  networking.firewall = {
    enable = true;
  };
  security = {
    polkit.enable = true;
    sudo.enable = false; # disable sudo by default, nh requires sudo to be present for now
    doas = {
      enable = true;
      wheelNeedsPassword = true;
      extraRules = [
        {
          users = [mainUser];
          keepEnv = true; # Optional, retains environment variables while running commands
          persist = true; # Optional, creates a rule for user to persist passwords after prompting a single time (per session)
        }
      ];
    };
    apparmor.packages = [
      # idk if this does anything, aa-status --profiled gives no loaded profiles
      pkgs.roddhjav-apparmor-rules
    ];
  };
  services.dbus.apparmor = lib.mkIf config.security.apparmor.enable "enabled"; # required seems to fail

  environment.systemPackages = with pkgs; [
    doas-sudo-shim # make sudo command work for scripts (and myself)
    vulnix # scan for CVEs on system
  ];
  /*
  nix-mineral = {
    enable = true;
    overrides = {
      # see https://github.com/cynicsketch/nix-mineral/blob/main/nix-mineral.nix for a list of all overrides
      performance = {
        allow-smt = true;
      };
      security = {
        lock-root = true;
        disable-intelme-kmodules = true;
        disable-tcp-window-scaling = true; # unless someone gets on my network ddos protection is not needed
      };
    };
  };
  # add a systemd.tmpfiles rule to ignore certain paths that could slow the boot process down
  systemd.tmpfiles.settings = {
    "restricthome" = lib.mkForce {}; # the restricthome option makes my system take 14 minutes to boot, so Ill disable it for now
  };
  boot = {
    specialFileSystems = {
      "/proc".options = lib.mkForce ["nosuid" "nodev" "noexec"]; # skipping the nix mineral proc stuff entirely, the issue seems to be a part of nixos stable (24.05) not recognising the nix-mineral gid=proc mount option (a bug prevents the script from filling this with an id)
    };
  };
  # since impernamence requires the /var and /etc directories they are mounted before the rest of the initrd is done, this causes conflict as they do not exist in the tmpfs / partition
  # therefore I will force them to be tmpfs instead
  fileSystems = {
    "/root" = lib.mkForce {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=256M"
        "mode=700"
        "nosuid"
        "noexec"
        "nodev"
      ];
    };
    # noexec on /var(/lib) may cause breakage (tho there shouldnt be anything there in this case)
    "/var" = lib.mkForce {
      device = "none";
      fsType = "tmpfs";
      options = [
        "mode=755"
        "size=2G"
        "nosuid"
        "noexec"
        "nodev"
      ];
    };
    "/etc" = lib.mkForce {
      device = "none";
      fsType = "tmpfs";
      options = [
        "mode=755"
        "size=512M"
        "nosuid"
        "nodev"
      ];
    };
  };
  */
}
