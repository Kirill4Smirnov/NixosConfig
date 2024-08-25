{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #hyprland.url = "github:hyprwm/Hyprland?submodules=1";

#    nixcfg.url = "github:averyanalex/nixcfg";

    nur.url = "github:nix-community/NUR";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nixpkgs-amnezia.url = "github:averyanalex/nixpkgs/amneziawg";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    #nixcfg,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.KenNix = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        #    username = "kenlog";
        #    hyprlandConfig = "laptop";
        inherit inputs;
      };
      modules = [
        home-manager.nixosModule
        nixcfg.nixosModules.default
#        ({inputs, ...}: {
#          nixcfg = {
#            username = "kenlog";
#            desktop = true;
#            inherit inputs;
#          };
#        })
        ./configuration.nix
        ./Modules
      ];
    };
  };
}
