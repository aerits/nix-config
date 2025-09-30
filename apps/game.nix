{
  config,
  lib,
  pkgs,
  ...
}:

let
  tetrio-plus = pkgs.tetrio-plus;
  stdenv = pkgs.gccStdenv;
  makeWrapper = pkgs.makeWrapper;
  electron = pkgs.electron;
  addDriverRunpath = pkgs.addDriverRunpath;
  fetchzip = pkgs.fetchzip;
  dpkg = pkgs.dpkg;
  tetrio-new = import ./tetrio.nix {
    inherit
      stdenv
      lib
      dpkg
      fetchzip
      makeWrapper
      addDriverRunpath
      electron
      tetrio-plus
      ;
  };
in
{
  environment.systemPackages = with pkgs; [
    tetrio-new
  ];
}
