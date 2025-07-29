{
  description = "dicedmangoes's nixos config";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-xr,
    }:
    {
      nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./fix-flatpaks.nix
          nixpkgs-xr.nixosModules.nixpkgs-xr
        ];
      };
    };
}
