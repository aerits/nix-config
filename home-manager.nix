{ config, pkgs, ... }:
let
  home-manager = (
    let
      lock = builtins.fromJSON (builtins.readFile ./flake.lock);
    in builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/${lock.nodes.home-manager.locked.rev}.tar.gz";
      sha256 = lock.nodes.home-manager.locked.narHash;
    }
  );
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  # unstableTarball =
  #   fetchTarball
  #     https://github.com/NixOs/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  
  # (import (
  #   let
  #     lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  #   in builtins.fetchTarball {
  #     url = "https://github.com/nix-community/home-manager/archive/${lock.nodes.home-manager.locked.rev}.tar.gz";
  #     sha256 = lock.nodes.home-manager.locked.narHash;
  #   }
  # ))
  # nixpkgs.config = {
  # packageOverrides = pkgs: {
  # unstable = import unstableTarball {
  # config = config.nixpkgs.config;
  # };
  # };
  # };
  
  home-manager.users.diced = {
    home.stateVersion = "23.05";

    home.packages = with pkgs; [
      # internet
      mullvad-browser
      tetrio-desktop
      librewolf
      brave
      tor-browser-bundle-bin
      qbittorrent
      ani-cli

      # chat
      teamspeak_client
      element-desktop
      # armcord
      webcord

      # media
      mpv

      # gaming
      osu-lazer-bin
      rpcs3
      protonup-ng

      # videos
      kdenlive
      obs-studio
      audacity

      # misc
      qemu
      anki-bin
      pfetch
      keepassxc
      foliate
      krita

      # temrinal apps
      ytfzf
      cmus
      yt-dlp
      ytmdl
      w3m

      # emacs-everywhere
      wl-clipboard
      ydotool
      xdotool
      xorg.xprop
      xorg.xwininfo
    ];

    programs.git = {
      enable = true;
      userName = "aerits";
      userEmail = "stev_nm@protonmail.com";

      extraConfig = {
        credential.helper = "${
	        pkgs.git.override {withLibsecret = true; }
        }/bin/git-credential-libsecret";
	      safe = {
          directory = "/etc/nixos";
	      };
      };
    };

    home.file.".config/alacritty/alacritty.yml".source=./alacritty.yml;
    home.file.".config/nvim/init.lua".source=./nvim.lua;
    home.file.".config/mpv/scripts".source=./mpv/scripts;
    home.file.".config/mpv/script-opts".source=./mpv/script-opts;

  };
}
