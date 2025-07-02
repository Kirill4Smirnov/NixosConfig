{pkgs, ...}: {
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    radeontop
    rocmPackages.clr
    rocmPackages.clr.icd
    rocmPackages.rocm-runtime
  ];
}
