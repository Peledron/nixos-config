{
  pkgs,
  config,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true; # true is default, allows extentions to be installed
    extensions = with pkgs.vscode-extensions; [
      # https://search.nixos.org/packages?channel=24.05&from=0&size=50&sort=relevance&type=packages&query=vscode-extensions
      bbenoist.nix
      jnoortheen.nix-ide
      kamadorueda.alejandra # needs alejandra installed

      file-icons.file-icons
      esbenp.prettier-vscode

      donjayamanne.githistory # see git history and diff
      ms-azuretools.vscode-docker
      davidlday.languagetool-linter # languagetool integration
      mkhl.direnv

      golang.go

      rust-lang.rust-analyzer

      ms-vscode.powershell
      mads-hartmann.bash-ide-vscode
      bmalehorn.vscode-fish

      bungcip.better-toml
      redhat.vscode-yaml
      zainchen.json
      irongeek.vscode-env
      yzhang.markdown-all-in-one
    ];
    userSettings = {
      "explorer.confirmDragAndDrop" = false;
      #"editor.fontFamily" = config.stylix.fonts.monospace.name; # already set by stylix
      #"editor.fontSize" = config.stylix.fonts.sizes.terminal;

      "nix" = {
        "enableLanguageServer" = true;
        "serverPath" = "${pkgs.nil}/bin/nil";
        "serverSettings" = ''"nil": {"formatting": { "command": ["alejandra", "--"] }}'';
      };
      "files.autoSave" = "afterDelay";
    };
  };
}
