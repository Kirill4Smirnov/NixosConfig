{pkgs, ...}: {
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  security.pam.services.gdm-autologin.enableGnomeKeyring = true;
}
