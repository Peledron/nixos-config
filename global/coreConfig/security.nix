{
  lib,
  pkgs,
  mainUser,
  ...
}: {
  nm-overrides = lib.mkDefault {
    # see https://raw.githubusercontent.com/cynicsketch/nix-mineral/main/nm-overrides.nix for a list of all overrides
    performance = {
      allow-smt.enable = true;
    };
    security = {
      lock-root.enable = true;
      disable-intelme-kmodules.enable = true;
      disable-tcp-window-scaling.enable = true; # unless someone gets on my network ddos protection is not needed
    };
    desktop.doas-sudo-wrapper.enable = true;
  };
  networking.firewall = lib.mkDefault {
    enable = true;
  };
  security = lib.mkDefault {
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
  security.apparmor.packages = [pkgs.apparmor-profiles pkgs.roddhjav-apparmor-rules];
}
