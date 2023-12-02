{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.hikari
  ];

}
