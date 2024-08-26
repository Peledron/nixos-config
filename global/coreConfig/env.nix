{
  lib,
  ...
}: {
  environment.sessionVariables = lib.mkDefault {
    EDITOR = "vi";
  };
}
