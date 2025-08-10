{
  config,
  lib,
  pkgs,
  ...
}:

{
  # hyprland is scuffed
  # do not use
  # has cool eyecandy though
  services.displayManager.sddm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };
  environment.systemPackages = with pkgs; [
    hyprlock
    hypridle
    hyprpaper
    hyprpicker
    hyprpolkitagent
    mako
    nwg-panel
    fuzzel
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
}
