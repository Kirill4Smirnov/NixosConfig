{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  username = "kenlog";
  hostName = "KenNix";
  flakePath = "/home/kenlog/Configuration";
in {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-486bb194-339e-47d8-bb1e-0b9b1aaf2a32".device = "/dev/disk/by-uuid/486bb194-339e-47d8-bb1e-0b9b1aaf2a32";

  networking.hostName = hostName;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.extraLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
  ];

  hardware.graphics.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "qtwebengine-5.15.19"
    ];
  };

  services = {
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = username;
      };
    };

    desktopManager.gnome.enable = true;

    printing.enable = true;

    libinput.enable = true;

    pulseaudio.enable = lib.mkForce false;

    # pipewire = {
    #   enable = true;
    #   alsa.enable = true;
    #   alsa.support32Bit = true;
    #   pulse.enable = true;
    # };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings.hosts = [
      "unix:///var/run/docker.sock"
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.nushell;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };

  programs.partition-manager.enable = true;
  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    flake = flakePath;
  };

  hm.programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      {package = vitals;}
      # {package = hibernate-status-button;}
      {package = power-off-options;}
      {package = blur-my-shell;}
    ];
  };

  environment = {
    systemPackages = with pkgs; let
      base = [
        amnezia-vpn
        vim
        wget
      ];

      systemTools = [
        inxi
        htop
        pciutils
      ];

      devTools = [
        go
        golangci-lint
        rustup
        clang-tools
        clang
        cmake
        ninja
        gnumake
        android-tools
        uv
      ];

      desktopApps = [
        gimp
        # terminator
        # gparted
        gnome-tweaks
        gnome-themes-extra
        power-profiles-daemon
        # telegram-desktop
        ayugram-desktop
        signal-desktop
        keepassxc
        obs-studio
        rnote
        libreoffice
        texliveFull
        kdePackages.okular
        vlc
        endeavour
        code-cursor
        docker-compose
        # jetbrains.clion
        obsidian
        flclash
      ];

      cliNice = [
        fzf
        git
        neofetch
        alejandra
        eza
        # bottles
        # tribler # doesn't have a desktop entry, starting from terminal gives a web interface
        ncdu
        dust
        neovim
        pipes-rs
        cmatrix
        btop
        p7zip
        libGL
        unrar
        asciinema
      ];
    in
      base
      ++ systemTools
      ++ devTools
      ++ desktopApps
      ++ cliNice;

    variables.EDITOR = "nvim";
    extraOutputsToInstall = [
      "dev"
    ];
    sessionVariables = {
      GDK_DISABLE = "gles-api";
      LIBGL_DEBUG = "verbose";
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
