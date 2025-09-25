{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-486bb194-339e-47d8-bb1e-0b9b1aaf2a32".device = "/dev/disk/by-uuid/486bb194-339e-47d8-bb1e-0b9b1aaf2a32";

  boot.loader.systemd-boot.memtest86.enable = true;

  networking.hostName = "KenNix"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Moscow";

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  hardware.graphics = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pulseaudio.enable = lib.mkForce false;
  #services.pipewire = {
  #  enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #  pulse.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  virtualisation.docker.enable = true;

  users.users.kenlog = {
    isNormalUser = true;
    extraGroups = ["wheel" "input" "networkmanager" "docker"];
    shell = pkgs.nushell;
  };

  # nix.settings.experimental-features = ["nix-command" "flakes"];

  #boot.kernelModules = [ "lenovo-legion-module" ];
  #boot.extraModulePackages = [config.boot.kernelPackages.lenovo-legion-module];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };

  programs.partition-manager.enable = true;
  # services.flatpak.enable = true;

  hm.programs.gnome-shell = {
    enable = true;
    extensions = with pkgs; [
      {package = gnomeExtensions.vitals;}
      {package = gnomeExtensions.hibernate-status-button;}
      {package = gnomeExtensions.blur-my-shell;}
    ];
  };

  # services.systemd

  programs.nh = {
    enable = true;
    flake = "/home/kenlog/Configuration";
  };

  environment.systemPackages = with pkgs; [
    amnezia-vpn
    vim
    wget

    inxi
    htop
    pciutils
    go
    golangci-lint
    rustup

    gimp
    # terminator
    # gparted
    gnome-tweaks

    power-profiles-daemon
    # telegram-desktop
    keepassxc
    fzf
    git
    neofetch
    obs-studio
    alejandra
    rnote
    eza
    # bottles
    # tribler # doesn't have a desktop entry, starting from terminal gives a web interface
    ncdu
    dust
    neovim
    libreoffice
    # planify
    # texmaker
    texliveFull
    pipes-rs
    cmatrix
    kdePackages.okular
    btop
    vlc
    p7zip
    clang-tools
    clang
    cmake
    ninja
    gnumake
    libGL
    android-tools
    uv
    unrar
    ayugram-desktop
    endeavour

    # code-cursor
    # jetbrains.clion
    obsidian
    # zoom-us
    # mathematica

    gnome-themes-extra
  ];

  programs.nix-ld.enable = true;

  environment.variables.EDITOR = "vim";
  environment.extraOutputsToInstall = ["dev"];
  environment.sessionVariables = {
    "GDK_DISABLE" = "gles-api";
    "LIBGL_DEBUG" = "verbose";
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
