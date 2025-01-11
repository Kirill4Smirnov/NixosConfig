{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  kver = config.boot.kernelPackages.kernel.version; # variable not used at the moment
in {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-47226b1a-1d7e-49d3-9ed0-d8e2fd63af57".device = "/dev/disk/by-uuid/47226b1a-1d7e-49d3-9ed0-d8e2fd63af57";

  boot.loader.systemd-boot.memtest86.enable = true;

  networking.hostName = "KenNix"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Moscow";

  services.xserver.enable = true;

  #services.displayManager.sddm.wayland.enable = true;
  #services.desktopManager.plasma6.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  hardware.graphics = {
    enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
  };

  nixpkgs.config.allowUnfree = true;
  # this trick with predicate wasn't working (the packages weren't been installed)
  #nixpkgs.config.allowUnfreePredicate = pkg:
  #  builtins.elem (lib.getName pkg) [
  #    "obsidian"
  #    "zoom-us"
  #  ];

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kenlog = {
    isNormalUser = true;
    extraGroups = ["wheel" "input" "networkmanager"]; # Enable ‘sudo’ for the user.
    shell = pkgs.nushell;
  };

  # nix.settings.experimental-features = ["nix-command" "flakes"];

  #boot.kernelModules = [ "lenovo-legion-module" ];
  boot.extraModulePackages = [config.boot.kernelPackages.lenovo-legion-module];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs.partition-manager.enable = true;

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
    #wezterm
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
    tribler
    ncdu
    dust
    neovim
    libreoffice
    planify
    texmaker
    texliveFull
    pipes-rs
    cmatrix
    kdePackages.okular
    btop

    obsidian
    # zoom-us
    # mathematica
  ];

  environment.variables.EDITOR = "vim";

  system.stateVersion = "24.05"; # Did you read the comment?

  #boot.resumeDevice = "/dev/mapper/crypted";
}
