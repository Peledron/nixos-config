{pkgs, ...}: {
  # enable the xserver:
  services = {
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true; # launch sddm in wayland
      };
    };
    desktopManager.plasma6.enable = true;
  };
  programs.dconf.enable = true; # better compatiblity for costum setups (gnome apps)
  #programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
  # --> install kde specific packages:
  environment.systemPackages = with pkgs.unstable; [
  ];
}
