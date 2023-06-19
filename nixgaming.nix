{pkgs, ...}: let
  nix-gaming = import (builtins.fetchTarball {
    url ="https://github.com/fufexan/nix-gaming/archive/9c7595826e2eeb2ba166430d03b5a9ca4e5c0e6c.tar.gz";
    sha256 = "0ivyq5sb58xcaw9gjqqqn0ajcznawpnlnb9zij4i5b5p43p19hra";
  });
in {
  # import the low latency module
  imports = [
    
  ];

  # programs.gamemode.enable = true;
  
  # install packages
  environment.systemPackages = [ # or home.packages
    # nix-gaming.packages.${pkgs.hostPlatform.system}.osu-stable
  ];
  
}
