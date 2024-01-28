{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    #####################3 coding
    git
    # nodejs
    # sbcl
    # openjdk
    # rustc
    # cargo
    # cmake
    # rust-analyzer

    # cloudflared
    # code-server

    # android
    # android-tools
    # scrcpy
    # soundwireserver

    #python
    # (python311.withPackages(ps: with ps;
    #   [
    #     # eaf stuff
    #     pandas
    #     requests
    #     pyqt6 sip qtpy /*qt6.qtwebengine*/ epc lxml pyqt6-webengine # for eaf
    #     qrcode # eaf-file-browser
    #     pysocks # eaf-browser
    #     pymupdf # eaf-pdf-viewer
    #     pypinyin # eaf-file-manager
    #     psutil # eaf-system-monitor
    #     retry # eaf-markdown-previewer
    #     markdown

    #     # stuff
    #     numpy
    #     tkinter
    #     jedi-language-server
    #     requests
    #     matplotlib]))

    # # eaf
    # qt6.qtwebengine
    # # git nodejs
    # wmctrl /*xdotool*/
    # # eaf-browser
    # aria 
    # # eaf-file-manager
    # fd
    
    # lsp
    rnix-lsp
    nil

    # latex
    # texlive.combined.scheme-full

    # typst
    # typst

    # for dirvish
    fd
    imagemagick
    poppler
    ffmpegthumbnailer
    mediainfo
    unzip

    # alactritty
    # gcc
    # docker
    # docker-compose

    # ide
    # vscode
    # godot_4

    # vnc
    # turbovnc
  ];
}
