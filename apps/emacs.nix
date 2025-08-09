{
  config,
  lib,
  pkgs,
  ...
}:

{

  services.emacs.enable = true;

  environment.systemPackages = with pkgs; [

    # emacs stuff
    android-tools
    uutils-findutils
    ripgrep
    nil # nix lsp
    aspell
    nh
    nodePackages_latest.prettier
    nixfmt-rfc-style

    # dirvish
    fd
    poppler
    mediainfo
    imagemagick
    ffmpegthumbnailer
    unzip
    # dirvish
  ];
}
