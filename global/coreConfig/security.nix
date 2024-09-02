{
  lib,
  pkgs,
  mainUser,
  ...
}: {
  networking.firewall = {
    enable = true;
  };
  security = {
    polkit.enable = true;
    sudo.enable = lib.mkForce false; # disable sudo by default
    doas = {
      enable = true;
      wheelNeedsPassword = true;

      extraRules = [
        # creates a rule for user to persist passwords after prompting a single time (per session)
        {
          users = [mainUser];
          keepEnv = true; # Optional, retains environment variables while running commands
          persist = true; # Optional, only require password verification a single time
        }
      ];

      # -> extraRules does not seem to apply in doas.conf so I'll use extraConfig instead
      #extraConfig = ''
      #  permit persist keepenv ${mainUser}
      #'';
    };
  };
  environment.systemPackages = with pkgs; [
    doas-sudo-shim
    apparmor-profiles
    roddhjav-apparmor-rules
  ];

  nm-overrides = {
    # see https://raw.githubusercontent.com/cynicsketch/nix-mineral/main/nm-overrides.nix for a list of all overrides
    performance = {
      allow-smt.enable = true;
    };
    security = {
      lock-root.enable = true;
      disable-intelme-kmodules.enable = true;
      disable-tcp-window-scaling.enable = true; # unless someone gets on my network ddos protection is not needed
    };
    desktop = {
      #hideproc-relaxed.enable = true;
      doas-sudo-wrapper.enable = true;
    };
  };
  # add a systemd.tmpfiles rule to ignore certain paths that could slow the boot process down
  systemd.tmpfiles.settings."restricthome" = lib.mkAfter {
    # see https://www.freedesktop.org/software/systemd/man/tmpfiles.d to see what the first letter means
    "/home/${mainUser}/.snapshots".x.age = "-"; # x means ignore recursivly
    "/home/${mainUser}/.cache".x.age = "-";
    "/home/${mainUser}/Data/Windows".x.age = "-";
  };
  boot = {
    specialFileSystems = {
      "/proc".options = lib.mkForce ["nosuid" "nodev" "noexec"]; # skipping the nix mineral proc stuff entirely, the issue seems to be a part of nixos stable (24.05) not recognising the nix-mineral gid=proc mount option (a bug prevents the script from filling this with an id)
    };
    /*
    # as tmpfs is used there the / partition is not populated with directories, this creates a situation where nix-minerals filesystem mount options wait for devices (folders) that do not yet exist, therefore we need to create them before filesystems are mounted
    initrd.postDeviceCommands = lib.mkAfter ''
      mkdir -p /mnt-root/home /mnt-root/root /mnt-root/var /mnt-root/srv /mnt-root/etc
    ''; # the mkdir -p option should prevent the command from running when the directory already exists (to avoid conflict with other nixos scripts)
    */
  };
  # since impernamence requires the /var and /etc directories they are mounted before the rest of the initrd is done, this causes conflict
  # therefore I will force them to be tmpfs instead
  fileSystems = {
    # You do not want to install applications here anyways.
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
    # noexec on /var(/lib) may cause breakage. See overrides.
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
}
