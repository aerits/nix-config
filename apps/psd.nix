{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.profile-sync-daemon
  ];
  systemd.user.services.psd.wantedBy = [ "default.target" ];
  systemd.user.services.psd-resync.wantedBy = [ "default.target" ];
}
