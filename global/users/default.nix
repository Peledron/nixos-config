{
  lib,
  self,
  ...
}: let
  # This function will import all usr.nix files in subdirectories
  importUserConfigs = dir:
    builtins.mapAttrs
    (name: _: import (dir + "/${name}/usr.nix"))
    (lib.filterAttrs
      (name: type: type == "directory" && builtins.pathExists (dir + "/${name}/usr.nix"))
      (builtins.readDir dir));

  # Import all user configurations
  userConfigs = importUserConfigs ./.;

  # Function to create a user configuration
  mkUserConfig = username: {...}:
    lib.mkIf (builtins.hasAttr username userConfigs) {
      imports = [userConfigs.${username}];
    };

  # Function to get the path of a user's home configuration
  getUserHomePath = username: path:
    self + "/global/users/${username}/home/${path}";
in {
  inherit mkUserConfig getUserHomePath;
  users = builtins.attrNames userConfigs;
}
