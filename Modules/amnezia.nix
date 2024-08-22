{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      amnezia = import inputs.nixpkgs-amnezia {
        system = "x86_64-linux";
        config = {allowUnfree = true;};
      };
    })
  ];

  boot.kernelPackages = pkgs.amnezia.linuxKernel.packages.linux_lts;
  boot.extraModulePackages = [config.boot.kernelPackages.amneziawg];
  environment.systemPackages = [
    pkgs.amnezia.amneziawg-tools
  ];
}
