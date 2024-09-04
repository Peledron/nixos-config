{...}: {
  programs.vscode = {
    enable = true;
    extentions = with pkgs.vscode-extensions; [
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
  };
}
