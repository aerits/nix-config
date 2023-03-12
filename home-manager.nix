{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.diced = {
    home.stateVersion = "18.09";

    home.packages = [
      pkgs.librewolf
      pkgs.thunderbird
      pkgs.ungoogled-chromium
      pkgs.git
      pkgs.pfetch
      pkgs.keepassxc
      pkgs.element-desktop
      pkgs.armcord
      pkgs.tor-browser-bundle-bin
      pkgs.foliate
      /*doom-emacs*/
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

  };
}
