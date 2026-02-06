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
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-xr,
      nixowos,
      lix,
      lix-module,
      nix-minecraft,
      spicetify-nix,
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./pc/configuration.nix
          ./pc/hardware-configuration.nix
          ./apps/fix-flatpaks.nix
          ./apps/appimage.nix
          ./apps/vr.nix
          ./apps/emacs.nix
          ./apps/torrenting.nix
          ./apps/game.nix
          ./apps/mc-server.nix
          ./apps/spotify.nix
          ./de/kde.nix
          ./cachix.nix
          nixpkgs-xr.nixosModules.nixpkgs-xr
          # nixowos.nixosModules.default
          # { nixowos.enable = true; }
          lix-module.nixosModules.default
        ];
      };
    };
}
