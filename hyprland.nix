{pkgs, ...}: 
{
  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [

    # hyprland stuff
    wofi
    hyprpaper
    waybar
    mako
    kitty
    waylock
    pulseaudio
    networkmanagerapplet
    pasystray
    pavucontrol
    xfce.thunar
    grim
    slurp
    networkmanager
  ];
}
