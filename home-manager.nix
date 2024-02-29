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
    # <home-manager/nixos>
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "pulsar-1.109.0"
  ];
  # nixpkgs.config = {
  #   packageOverrides = pkgs: {
  #     unstable = import unstableTarball {
  #       config = config.nixpkgs.config;
  #     };
  #   };
  # };

  # tailscale
  services.tailscale.enable = true;

  home-manager.users.diced =  {
    home.stateVersion = "18.09";

    home.packages = [
      # librewolf
      # pkgs.qutebrowser
      # pkgs.nyxt
      # pkgs.mullvad-browser
      pkgs.librewolf
      pkgs.libreoffice
      # pkgs.matrix-commander
      pkgs.keepassxc
      pkgs.tor-browser-bundle-bin
      # pkgs.foliate
      # pkgs.ppsspp
      pkgs.godot_4
      pkgs.vscode
      pkgs.riseup-vpn

      pkgs.teamspeak_client

      # pkgs.gnuplot

      # pkgs.xclip

      pkgs.wl-clipboard

      # pkgs.unityhub

      # pkgs.xorg.xmodmap

      pkgs.ispell
      pkgs.anki
      pkgs.melonDS

      # pkgs.rlaunch

      # used for nov.el in emacs
      pkgs.unzip

      pkgs.texlive.combined.scheme-full
      pkgs.mpv

      pkgs.w3m
      pkgs.gallery-dl

      pkgs.distrobox
      # pkgs.st

      # for emacs
      # pkgs.pantalaimon

      # pkgs.rofi

      # pkgs.nyxt

      # eaf
      #python
      (pkgs.python311.withPackages(ps: with ps;
        [
          # eaf stuff
          # pandas
          # requests
          # pyqt6 sip qtpy /*qt6.qtwebengine*/ epc lxml pyqt6-webengine # for eaf
          # qrcode # eaf-file-browser
          # pysocks # eaf-browser
          # pymupdf # eaf-pdf-viewer
          # pypinyin # eaf-file-manager
          # psutil # eaf-system-monitor
          # retry # eaf-markdown-previewer
          # markdown

          # stuff
          numpy
          tkinter
          # jedi-language-server
          matplotlib]))
      # # eaf
      # pkgs.qt6.qtwebengine
      # # # git
      # pkgs.nodejs
      # pkgs.wmctrl
      # pkgs.xdotool
      # # eaf-browser
      # pkgs.aria 
      # # eaf-file-manager
      # pkgs.fd
    ];

    programs.git = {
      enable = true;
      userName = "aerits";
      userEmail = "stev_nm@protonmail.com";

      extraConfig = {
        #       credential.helper = "${
	      #     pkgs.git.override {withLibsecret = true; }
        #         }/bin/git-credential-libsecret";
	      # safe = {
        #         directory = "/etc/nixos";
        credential.helper = "store";
      };
    };

    # set cursor theme
    # gtk.cursorTheme = {
    # package = pkgs.capitaine-cursors;
    # name = "Capitaine Cursors";
    # };

    # home.file.".config/nvim/init.lua".source=./nvim.lua;

  };
}
