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
      thunderbird
      ungoogled-chromium
      tor-browser-bundle-bin

      # chat
      teamspeak_client
      element-desktop
      armcord

      # gaming
      osu-lazer-bin
      grapejuice
      protonup-ng

      # misc
      pfetch
      keepassxc
      foliate
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

  };
}
