{pkgs, ...}: let
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in {
  # import the low latency module
  imports = [
  ];

  programs.gamemode.enable = true;
  
  # install packages
  environment.systemPackages = [ # or home.packages
    nix-gaming.packages.${pkgs.hostPlatform.system}.osu-stable
  ];
  
}
