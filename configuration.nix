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

  boot.initrd.luks.devices."luks-47226b1a-1d7e-49d3-9ed0-d8e2fd63af57".device = "/dev/disk/by-uuid/47226b1a-1d7e-49d3-9ed0-d8e2fd63af57";

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
  boot.extraModulePackages = [config.boot.kernelPackages.lenovo-legion-module];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };

  programs.partition-manager.enable = true;
  services.flatpak.enable = true;

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
    vim
    wget
    lenovo-legion

    inxi
    htop
    pciutils

    nushell
    # inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop

    gimp
    terminator
    # gparted
    gnome-tweaks
    vimix-cursors

    power-profiles-daemon
    telegram-desktop
    keepassxc
    fzf
    git
    neofetch
    obs-studio
    alejandra
    rnote
    eza
    bottles
    # tribler
    ncdu
    dust
    neovim
    libreoffice
    # planify
    texmaker
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
    ayugram-desktop

    code-cursor
    jetbrains.clion
    obsidian
    # zoom-us
    # mathematica

    flatpak
  ];

  programs.nix-ld.enable = true;

  environment.variables.EDITOR = "vim";
  environment.extraOutputsToInstall = ["dev"];
  environment.sessionVariables = {
    "GDK_DISABLE" = "gles-api";
    "LIBGL_DEBUG" = "verbose";
  };

  system.stateVersion = "24.05"; # Did you read the comment?

  #boot.resumeDevice = "/dev/mapper/crypted";
}
