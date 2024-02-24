{config, pkgs, ...}:
{
  imports = [
    # ./apps/emacs/emacs.nix
    ./apps/waydroid.nix
  ];
}
