{
  description = "dicedmangoes's nixos config";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixowos = {
      url = "github:yunfachi/nixowos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-xr,
      nixowos,
      lix,
      lix-module,
    }:
    {
      nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
        modules = [
          ./pc/configuration.nix
          ./pc/hardware-configuration.nix
          ./apps/fix-flatpaks.nix
          ./apps/vr.nix
          ./apps/emacs.nix
          ./apps/torrenting.nix
          ./apps/gnome-boxes.nix
          ./de/kde.nix
          nixpkgs-xr.nixosModules.nixpkgs-xr
          nixowos.nixosModules.default
          { nixowos.enable = true; }
          lix-module.nixosModules.default
        ];
      };
    };
}
