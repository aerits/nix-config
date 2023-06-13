{ config, pkgs, ...}:
{
  services.tailscale.enable = true;
  # eaf
  environment.variables = {
    QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt5.qtbase.bin.outPath}/lib/qt-${pkgs.qt5.qtbase.version}/plugins";
  };

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
          # eaf stuff
          pandas
          requests
          pyqt6 sip qtpy /*qt6.qtwebengine*/ epc lxml pyqt6-webengine # for eaf
          qrcode # eaf-file-browser
          pysocks # eaf-browser
          pymupdf # eaf-pdf-viewer
          pypinyin # eaf-file-manager
          psutil # eaf-system-monitor
          retry # eaf-markdown-previewer
          markdown

          # stuff
          numpy
          tkinter
          jedi-language-server
          requests
          matplotlib]))

      # eaf
      qt6.qtwebengine
      # git nodejs
      wmctrl /*xdotool*/
      # eaf-browser
      aria 
      # eaf-file-manager
      fd
      
      # lsp
      rnix-lsp
      nil

      # latex
      texlive.combined.scheme-full

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
