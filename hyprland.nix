{pkgs, ...}: 
{
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [

    # hyprland stuff
    wofi
    polkit_gnome
    hyprpaper
    waybar
    mako
    kitty
    sway
    libsForQt5.polkit-kde-agent
    waylock
    pulseaudio
    networkmanagerapplet
    pasystray
    pavucontrol
    xfce.thunar
    brightnessctl
    grim
    slurp
    networkmanager

  ];
}
