{config, pkgs, ...}:
{
  imports = [
    # ./apps/emacs/emacs.nix
    # ./apps/waydroid.nix
    ./apps/psd.nix
  ];

  programs.corectrl.enable = true;
}
