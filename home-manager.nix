{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";

  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = /home/diced/.config/doom.d;  # Directory containing your config.el, init.el
                                # and packages.el files
  };
  

in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.diced = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "18.09";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */

    home.packages = [
      pkgs.librewolf
      pkgs.thunderbird
      pkgs.ungoogled-chromium
      pkgs.git
      pkgs.pfetch
      pkgs.keepassxc
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
