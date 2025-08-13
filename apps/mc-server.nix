{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.minecraft-server.enable = true;
  services.minecraft-server.eula = true;
  environment.systemPackages = with pkgs; [
    cloudflared
  ];
}
