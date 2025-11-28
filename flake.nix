{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcfg.url = "github:kirill4smirnov/nixcfg";

    nur.url = "github:nix-community/NUR";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    mathematica-installer = {
      url = "/home/kenlog/Mathematica_14.0.0_BNDL_LINUX.sh";
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixcfg,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.KenNix = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        inherit inputs;
      };
      modules = [
        home-manager.nixosModules.default
        nixcfg.nixosModules.default
        ({inputs, ...}: {
          nixcfg = {
            username = "kenlog";
            desktop = true;
            gnome.enable = true;
            inherit inputs;
          };
        })
        ./configuration.nix
        ./Modules
      ];
    };
  };
}
