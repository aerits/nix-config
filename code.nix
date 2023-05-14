{ config, pkgs, ...}:
{
  home-manager.users.diced = {
    home.packages = with pkgs; [
      # coding
      git
      nodejs
      sbcl
      openjdk

      #python
      (python311.withPackages(ps: with ps;
        [
          numpy
          tkinter
          jedi-language-server
          matplotlib]))

      # lsp
      rnix-lsp

      # for dirvish
      fd
      imagemagick
      poppler
      ffmpegthumbnailer
      mediainfo
      unzip

      # alactritty
      gcc
      docker
      docker-compose

      # ide
      vscode

      # vnc
      turbovnc
    ];
    
  };
}
