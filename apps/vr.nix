{
  config,
  lib,
  pkgs,
  ...
}:

{

  services.wivrn = {
    enable = true;
    defaultRuntime = true;
    openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    motoc
    wlx-overlay-s

  ];
}
