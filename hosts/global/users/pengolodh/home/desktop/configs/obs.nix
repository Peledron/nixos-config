{
  config,
  pkgs,
  ...
}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs # wayland roots compatible screencapture
      obs-backgroundremoval
      obs-vaapi
      obs-gstreamer
      obs-pipewire-audio-capture
    ];
  };
}
