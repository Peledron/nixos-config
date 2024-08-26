{lib, ...}: {
  users.mutableUsers = lib.mkDefault false; # makes user config immutable by default, meaning that things like /etc/passwd are managed solely by the nix config, also disables commands that alter users (usermod, etc...)
}
