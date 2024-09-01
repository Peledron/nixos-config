{
  lib,
  pkgs,
  mainUser,
  ...
}: {
  /*
    nm-overrides = {
    # see https://raw.githubusercontent.com/cynicsketch/nix-mineral/main/nm-overrides.nix for a list of all overrides
    # note nm seems to be incompatible with the impernamence setup, so I am leaving it out for now
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

  boot.specialFileSystems = {
    "/proc".options = lib.mkForce ["nosuid" "nodev" "noexec"]; # skipping the nix mineral proc stuff entirely, the issue seems to be a part of nixos stable
  };
  */
  networking.firewall = lib.mkDefault {
    enable = true;
  };
  security = {
    polkit.enable = true;
    sudo.enable = false; # disable sudo by default
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
    #apparmor-profiles
    #roddhjav-apparmor-rules
  ];
}
