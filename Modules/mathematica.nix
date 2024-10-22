{pkgs ? import <nixpkgs> { }}:

pkgs.mathematica.override {
  source = pkgs.requireFile {
    name = "Mathematica_14.0.0_BNDL_LINUX.sh";
    sha256 = "0rmrspvf1aqgpvl9g53xmibw28f83vzrrhw6dmfm4l7y05cr315y";
    message = ''
      Your override for Mathematica includes a different src for the installer,
      and it is missing.
    '';
    hashMode = "recursive";
  };
}

