{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.waydroid
  ];
}
