{
  config,
  lib,
  pkgs,
  testers,
  ...
}:

let
  buildFHSEnv = pkgs.buildFHSEnv;
  envision = pkgs.envision;
  envision-unwrapped = pkgs.envision-unwrapped;
  envision-new = import ./envision.nix {
    inherit
      lib
      buildFHSEnv
      testers
      envision
      envision-unwrapped
      ;
  };
in
{
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };
  environment.systemPackages = with pkgs; [
    # guys i don't know how to write overlays, so i just copied the package from nixpkgs and modified it LMAO
    envision-new
    motoc
    wlx-overlay-s
  ];
}
