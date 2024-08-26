{...}: {
  # see https://nixos.wiki/wiki/Git
  programs.git = {
    enable = true; # set git config to be managed by home-manager
    userName = "pengolodh";
    userEmail = "lysander.deloore@gmail.com";
    extraConfig = {
      rerere.enabled = true; # REuse REcorded REsolution, saves some time for merge conflicts as it saves the method used for a particular type of merge
    };
  };
}
