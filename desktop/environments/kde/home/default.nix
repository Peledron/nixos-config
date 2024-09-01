{...}: let
  # this function will import any .nix files in the given directory, it will exclude anything else (like sub-directories)
  importDir = dir: let
    files = builtins.attrNames (builtins.readDir dir);
    isNixFile = file: (builtins.match ".*\\.nix" file) != null;
    nixFiles = builtins.filter isNixFile files;
  in
    builtins.map (f: dir + "/${f}") nixFiles;
in {
  imports =
    [
      ./env.nix
      ./pkgs.nix
    ]
    ++ (importDir ./configs);
}
