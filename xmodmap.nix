{ config, pkgs, ... }:
let

in
{
services.xserver.displayManager.sessionCommands =
  ${pkgs.xorg.xmodmap}/bin/xmodmap "${pkgs.writeText  "xkb-layout" ''
    clear Lock
    keysym Caps_Lock = Escape
    keysym Escape = Caps_Lock
    add Lock = Caps_Lock 
  ''}"
}
