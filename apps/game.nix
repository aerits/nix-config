{
  config,
  lib,
  pkgs,
  testers,
  ...
}:

let
  buildFHSEnv = pkgs.buildFHSEnv;
  tetrio-new = import ./tetrio.nix {
    inherit
      lib
      buildFHSEnv
      testers
      ;
  };
in
{
  environment.systemPackages = with pkgs; [

  ]
}
