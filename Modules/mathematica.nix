{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (mathematica.override {version = "14.0.0";})
  ];
}
