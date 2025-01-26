{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcfg.url = "github:averyanalex/nixcfg";

    nur.url = "github:nix-community/NUR";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nixpkgs-amnezia.url = "github:averyanalex/nixpkgs/amneziawg";

    # ayugram-desktop.url = "github:/ayugram-port/ayugram-desktop/release?submodules=1";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixcfg,
    # ayugram-desktop,
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
