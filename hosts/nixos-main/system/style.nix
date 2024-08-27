{self, ...}: let
  themingModulePath = "${self}/global/modules/theming";
in {
  imports = ["${themingModulePath}/daOneGray.nix"];
}
