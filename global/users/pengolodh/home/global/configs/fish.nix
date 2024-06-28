{
  config,
  lib,
  ...
}: {
  # see https://nixos.wiki/wiki/Fish
  programs.fish = {
    enable = lib.mkDefault false; # set fish to be managed by home-manager
    #==================#
    # fish config:
    # --> on intereractive shell launch fish will do the following:
    interactiveShellInit = ''
      begin
          set fish_greeting
          set VIRTUAL_ENV_DISABLE_PROMPT "1"

          fish_add_path ~/.local/bin
          fish_add_path ~/.cargo/bin

          source ~/.aliases
      end
    '';
    functions = {
      pull-config = ''pushd $FLAKE; git pull; popd'';
      push-config = ''pushd $FLAKE; git add --all; git commit -m "$argv"; git push; popd'';
    };
  };
  # ---
}
