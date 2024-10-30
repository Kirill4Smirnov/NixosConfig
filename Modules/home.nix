{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
  ];
}
