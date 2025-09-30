{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (tetrio-desktop.overrideAttrs {
      version = "10";
    })
  ];
}
