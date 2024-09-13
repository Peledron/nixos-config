{...}: {
  # see https://nixos.wiki/wiki/Git
  programs.git = {
    enable = true; # set git config to be managed by home-manager
    userName = "pengolodh";
    userEmail = "179588859+Peledron@users.noreply.github.com";
    extraConfig = {
      rerere.enabled = true; # REuse REcorded REsolution, saves some time for merge conflicts as it saves the method used for a particular type of merge
    };
  };
}
