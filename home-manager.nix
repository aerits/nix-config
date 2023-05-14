{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  unstableTarball =
    fetchTarball
      https://github.com/NixOs/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
  
  home-manager.users.diced = {
    home.stateVersion = "18.09";

    home.packages = with pkgs.unstable; [
      # internet
      librewolf
      mullvad-browser
      thunderbird
      brave
      tor-browser-bundle-bin
      qbittorrent

      # chat
      teamspeak_client
      element-desktop
      armcord

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
      wpsoffice
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

  };
}
