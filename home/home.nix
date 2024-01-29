{ config, pkgs, lib, ... }:
{
  imports = [ ./code.nix ];
  home.stateVersion = "23.05";

  home.username = "diced";
  home.homeDirectory = "/home/diced";

  home.packages = with pkgs; [
    # internet
    librewolf
    thunderbird
    tor-browser-bundle-bin
    qbittorrent

    # chat
    teamspeak_client
    element-desktop

    # media
    mpv

    appimage-run

    # gaming
    protonup-ng

    # videos
    obs-studio
    audacity
    openutau

    # misc
    anki-bin
    keepassxc
    krita

    # temrinal apps
    yt-dlp
    w3m
    wl-clipboard

  ];


  programs.git = {
    enable = true;
    userName = "aerits";
    userEmail = "stev_nm@protonmail.com";
    extraConfig.credential.helper = "libsecret";

  };
  
  # home.file.".config/alacritty/alacritty.yml".source=./alacritty.yml;
  # home.file.".config/nvim/init.lua".source=./nvim.lua;
  # home.file.".config/mpv/scripts".source=./mpv/scripts;
  # home.file.".config/mpv/script-opts".source=./mpv/script-opts;
  # home.file.".config/mpv/mpv.conf".source=./mpv/mpv.conf;

  # };
  # };
}
