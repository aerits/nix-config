{
  description = "dicedmangoes's nixos config";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
  inputs.lix = {
    url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    flake = false;
  };

  inputs.lix-module = {
    url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.lix.follows = "lix";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-xr,
      lix,
      lix-module,
    }:
    {
      nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./fix-flatpaks.nix
          nixpkgs-xr.nixosModules.nixpkgs-xr
          lix-module.nixosModules.default
        ];
      };
    };
}
