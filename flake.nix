{
  description = "flake for nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    # nix-gaming.url = "github:fufexan/nix-gaming";

    # niri.url = "github:sodiboo/niri-flake";
    # niri.inputs.niri-src.url = "github:YaLTeR/niri";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./apps.nix

          # nix gaming
          # ({pkgs, inputs, ...}: {
          #   environment.systemPackages = [ # or home.packages
          #     pkgs.gamemode
          #     inputs.nix-gaming.packages.${pkgs.system}.osu-stable # installs a package
          #   ];
          # })

          # (niri.nixosModules.niri)
          # ({config, pkgs, ...}: {
          #   environment.systemPackages = [
          #     pkgs.mako
          #     pkgs.waybar
          #     pkgs.swaybg
          #     pkgs.fuzzel
          #   ];
          #   programs.niri.enable = true;
          # })

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          (home-manager.nixosModules.home-manager)
          ({
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # TODO replace ryan with your own username
            home-manager.users.diced = import ./home/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix

          })
          
        ];
        
      };
    };
  };
}
