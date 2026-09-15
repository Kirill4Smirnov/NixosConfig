{...}: {
  imports = [
    ./Hardware/hardware-configuration.nix
    ./obs-virt-cam.nix
    ./firefox.nix
    ./vscode.nix
    ./firejail.nix
    ./brave.nix
    ./nushell.nix
    ./wezterm.nix
    ./open-webui.nix
    ./gnome-shell.nix
    ./v2ray.nix
  ];
}
