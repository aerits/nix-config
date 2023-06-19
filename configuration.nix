# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # unstableTarball =
  # fetchTarball
  # https://github.com/NixOs/nixpkgs/archive/nixos-unstable.tar.gz;

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';

in
{ 
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home-manager.nix
      ./emacs.nix
      ./code.nix
      ./nixgaming.nix
      ./cachix.nix
    ];
  
  # nixpkgs.config = {
  # packageOverrides = pkgs: {
  # unstable = import unstableTarball {
  # config = config.nixpkgs.config;
  # };
  # };
  # };

  # one of these commands is turning on flakes ig
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes
  '';
  };

  boot = {
    # bootloader
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
	      efiSysMountPoint = "/boot/efi";
      };
    };

    kernelPackages = pkgs.linuxPackages_zen;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    epiphany
    gnome.geary
    gnome.yelp
    gnome-console
  ]);

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # enable japanese input with fcitx as ime, and mozc as input method in fcitx
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    enable = true;
    user = "diced";
    dataDir = "home/diced/Documents";    # Default folder for new synced folders
    configDir = "/home/diced/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.diced = {
    isNormalUser = true;
    description = "diced";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # declared in home manager
    ];
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # system tools
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    ttyd
    unzip

    # for matrix
    pantalaimon

    # google-drive-ocamlfuse # for google drive stuff
    blackbox-terminal

    steam

    # gnome tweaks
    gnome.gnome-tweaks

    # gnome extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-panel

    # misc
    vorta
    ntfs3g
    prismlauncher-qt5
  ];

  # download fonts
  fonts.fonts = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-code-pro
    corefonts
    wqy_zenhei # for steam to show cjk fonts
  ];

  #make steam work
  # programs.steam = {
  # enable = true;
  # remotePlay.openFirewall = true;
  # dedicatedServer.openFirewall = true;
  # };

  hardware.opengl.driSupport32Bit = true; 

  # bluetooth
  hardware.bluetooth = {
    enable = true;
  };

  #nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    nvidiaBusId = "PCI:1:0:0";

    intelBusId = "PCI:0:02:0";
  };

  # enable flatpaks
  services.flatpak.enable = true;
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;

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
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    #permitRootLogin = "yes";
  };


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # set bash aliases
  programs.bash.shellAliases = {
    vim = "nvim";
    vi = "nvim";
    qr = "sh ./scripts/qr.sh";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
