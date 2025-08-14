{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.vanilla = {
      enable = true;
      autoStart = true;
      restart = "always";
      package = pkgs.minecraftServers.fabric-1_21_8;
      jvmOpts = "-Xmx4G -Xms2G";
      serverProperties = {
        motd = "WYSI WYSI WYSI WYSI 72727272727272 play.0000727.xyz";
        max-players = 727;
      };
    };

  };
  environment.systemPackages = with pkgs; [
    cloudflared
  ];
}
