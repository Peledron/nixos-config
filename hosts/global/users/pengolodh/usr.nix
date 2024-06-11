# user-specific config
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  # user system-level module imports:
  users = {
    users = {
      # Define a user account. Don't forget to set a password with ‘passwd’. or run mkpasswd and copy the hash in hashedPassword = "";
      # place new users here:
      # user pengolodh
      pengolodh = {
        isNormalUser = true;
        home = "/home/pengolodh"; # you can define a different home, /home/$USER is used by default
        #hashedPasswordFile = config.sops.secrets.pengolodh-password.path;
        #hashedPassword =; # password hash generated via mkpasswd -m sha-512
        initialPassword = "nimbus"; # change this with passwd on login
        extraGroups = ["wheel" "podman" "docker" "kvm" "libvirtd" "video" "networkmanager" "ubridge" "wireshark"]; # add user to groups for extra permissions like sudo access

        # ssh user specific settings:
        openssh = {
          # set ssh authorized keys
          authorizedKeys = {
            keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN2Ic51w68EFuVfoqvWo3xbZCYYyAdt2Mj4u6ZXh2pP" #nixos-pengolodh, stored in gitlab.com/pengolodh/dotfiles -> ssh/.ssh/home => its encrypted with git crypt using a gpg key
            ];
          };
        };
      };
    };
  };
}
