# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOs/nixpkgs/archive/nixos-unstable.tar.gz;

in
{ 
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home-manager.nix
      # ./emacs.nix
      ./cachix.nix
      ./hyprland.nix
    ];

  services.flatpak.enable = true;
  # needed for flatpaks on exwm
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # airpods i guess
  hardware.bluetooth.enable = true;
  
  # nixpkgs.config = {
  #   packageOverrides = pkgs: {
  #     unstable = import unstableTarball {
  #       config = config.nixpkgs.config;
  #     };
  #   };
  # };

  # optimise store
  nix.settings.auto-optimise-store = true;

  system.autoUpgrade = {
    enable = true;
    dates = "12:00";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot = {
    kernelParams = [ "quiet" "splash" ];
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" "8.8.8.8" "8.8.4.4"];
  
  # services.blueman.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # login manager
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.theme = "catppuccin-sddm-corners-unstable";

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # environment.gnome.excludePackages = (with pkgs; [
  #   gnome-tour
  #   epiphany
  #   gnome.geary
  #   gnome.yelp
  #   gnome-console
  # ]);
  #
  # kde plasma
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  
  # environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  #   # elisa
  #   # gwenview
  #   # okular
  #   # oxygen
  #   # khelpcenter
  #   # konsole
  #   # plasma-browser-integration
  #   # print-manager
  # ];

  # xfce
  # services.xserver = {
  #   libinput = {
  #     enable = true;
  #   };
  #   desktopManager = {
  #     #       # xfce = {
  #     #       #   enable = true;
  #     #       #   noDesktop = true;
  #     #       #   enableXfwm = false;
  #     #       # };
  #     default = "emacs";
  #     session = [ {
  #       manage = "desktop";
  #       name = "emacs";
  #       start = ''
  #                     pasystray &
  #                     nm-applet &
  #                     emacs
  #                     '';
  #       # '';
  #     }];
  #   };
  #   #displayManager.defaultSession = "xfce+i3";
  #   #windowManager.i3.enable = true;
  # };


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # enable japanese input with fcitx as ime, and mozc as input method in fcitx
  # i18n.inputMethod.enabled = "fcitx5";
  # i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.syncthing = {
    enable = true; user = "diced";
    dataDir = "/home/diced/Documents";
    configDir = "/home/diced/Documents/.config/syncthing";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.diced = {
    isNormalUser = true;
    description = "diced";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    packages = with pkgs; [
      #    	libreoffice
	    # matrix-commander
	    # keepassxc
	    # tor-browser-bundle-bin
	    # foliate
	    #
	    # emacs-gtk
	    # # ppsspp
	    # # nyxt
	    # 
    ];
  };

  # exwm
  # programs.slock.enable = true;

  # wayfire
  # programs.wayfire = {
  #   enable = true;
  #   plugins = with pkgs.wayfirePlugins; [
  #     wcm
  #     wf-shell
  #     wayfire-plugins-extra
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # system tools
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    nodejs
    # unstable.ttyd
    # blackbox-terminal
    # unstable.gcc
    cmake

    # gnome extensions
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    # gnomeExtensions.myhiddentopbar
    lm_sensors
    

    # steam stuff
    # unstable.protonup-ng

    # exwm
    # rofi
    # networkmanagerapplet
    # brightnessctl
    # alsa-utils
    # scrot
    # slock
    # # upower
    # tlp
    # playerctl
    # pavucontrol
    # pasystray
    

    # i3
    # nitrogen
    # rofi
    # xfce.xfce4-panel
    # xfce.xfce4-pulseaudio-plugin
    # xfce.xfce4-power-manager
    # xfce.xfce4-i3-workspaces-plugin
    # xfce.xfce4-power-manager
    # btop
    # pfetch
    # autotiling
    # xorg.setxkbmap

    # # hyprland stuff
    # wofi
    # polkit_gnome
    # hyprpaper
    # waybar
    # mako
    # kitty
    # sway
    # libsForQt5.polkit-kde-agent
    # waylock
    # pulseaudio
    # networkmanagerapplet
    # pasystray
    # pavucontrol
    # xfce.thunar
    # brightnessctl
    # grim
    # slurp
    # networkmanager
  ];

  # attempt at getting workspaces working in waybar
  # nixpkgs.overlays = [
  # (self: super: {
  #   waybar = super.waybar.overrideAttrs (oldAttrs: {
  #     mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  #   });
  # })
  # ];

  # add bash alias
  programs.bash.shellAliases = {
    # icat = "kitty +kitten icat";
    matrixlisten = "matrix-commander --listen forever --os-notify --listen-self &";
    matrixsend = "matrix-commander -m ";
  };

  # download fonts
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-code-pro
  ];

  # make steam work
  #programs.steam = {
  #  enable = true;
  #  remotePlay.openFirewall = true;
  #  dedicatedServer.openFirewall = true;
  #};

  #nvidia drivers
  #services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.opengl.enable = true;

  # enable flatpaks
  #services.flatpak.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
