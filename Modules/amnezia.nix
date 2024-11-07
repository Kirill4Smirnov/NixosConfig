{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      amnezia = import inputs.nixpkgs-amnezia {
        system = prev.system;
        config = {allowUnfree = true;};
      };
    })
  ];

  boot.kernelPackages = pkgs.amnezia.linuxKernel.packages.linux_zen;
  boot.extraModulePackages = [config.boot.kernelPackages.amneziawg];
  environment.systemPackages = [
    pkgs.amnezia.amneziawg-tools
  ];
}
