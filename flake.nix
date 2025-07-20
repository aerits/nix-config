{
  description = "dicedmangoes's nixos config";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  outputs = { self, nixpkgs }: {
    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
