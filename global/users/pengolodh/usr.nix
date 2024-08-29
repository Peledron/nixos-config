# user-specific config
{
  config,
  self,
  pkgs,
  ...
}: {
  age.secrets.users_pengolodh_password.file = "${self}/.secrets/users/pengolodh/password.age";
  users = {
    users = {
      pengolodh = {
        isNormalUser = true;
        home = "/home/pengolodh"; # you can define a different home, /home/$USER is used by default
        hashedPasswordFile = config.age.secrets.users_pengolodh_password.path; # make sure that the password is hashed in the age file
        extraGroups = ["wheel" "podman" "docker" "kvm" "libvirtd" "video" "networkmanager"]; # add user to groups for extra permissions like sudo access

        openssh = {
          authorizedKeys = {
            keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN2Ic51w68EFuVfoqvWo3xbZCYYyAdt2Mj4u6ZXh2pP" #nixos-pengolodh, stored in gitlab.com/pengolodh/dotfiles -> ssh/.ssh/home => its encrypted with git crypt using a gpg key
            ];
          };
        };
        packages = with pkgs; [
          pciutils
          usbutils
          lm_sensors
          fuse
          s3fs
        ];
      };
    };
  };
}
