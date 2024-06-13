{
  config,
  pkgs,
  ...
}: {
  # [import declared configs]
  imports = [(import ./env.nix)];
}
